start = Time.now

#Reset Database
Rake::Task['db:drop'].invoke
Rake::Task['db:create'].invoke
Rake::Task['db:migrate'].invoke

# Set Fake Data
@users = [
  {
    email: 'admin@admin.com',
    role: 'admin'
  }, {
    email: 'moderator@moderator.com',
    role: 'moderator'
  }, {
    email: 'content@content.com',
    role: 'content'
  }, {
    email: 'user@user.com',
    role: 'user'
  }, {
    email: 'banned@user.com',
    role: 'user',
    banned: true
  }
]
@artists = [
  {
    name: 'Казимир Малевич',
    died: 1935,
    born: 1879
  }, {
    name: 'Владимир Татлин',
    born: 1885,
    died: 1953
  }, {
    name: 'Павел Филонов',
    born: 1883,
    died: 1941
  }, {
    name: 'Илья Чашник',
    born: 1902,
    died: 1929
  }, {
    name: 'Марк Шагал',
    born: 1887,
    died: 1985
  }, {
    name: 'Эль Лисицкий',
    born: 1890,
    died: 1941
  }, {
    name: 'Александр Родченко',
    born: 1891,
    died: 1956
  }
]

@artwork_titles = [
  'Черный квадрат',
  'Башня третьего интернационала',
  'Амазонка'
]

@galleries = [
  {
    title: 'Супрематизм',
    teaser: 'Супремати́зм — направление в авангардистском искусстве, основанное в 1-й половине 1910-х годов К. С. Малевичем. Являясь разновидностью абстракционизма, супрематизм выражался в комбинациях разноцветных плоскостей простейших геометрических очертаний.',
    background: 'FF0000'
  }, {
    title: 'Кубизм',
    teaser: 'Кубизм (фр.cubisme, от cube – куб) – художественное направление во французском искусстве начала ХХ века, основателями и крупнейшими представителями которого были Пабло Пикассо и Жорж Брак.',
    background: '00FF00'
  }, {
    title: 'Авангард',
    teaser: 'Аванга́рд, авангарди́зм — обобщающее название течений в мировом, прежде всего в европейском искусстве, возникших на рубеже XIX и XX веков.',
    background: '0000FF'
  }, {
    title: 'Минимализм',
    teaser: 'Ми́нимал-арт (англ. Minimal art), также Минимали́зм (англ. Minimalism), Иску́сство ABC (англ. ABC Art) — художественное течение, возникшее в Нью-Йорке в 1960-х годах. В теории искусства обычно рассматривается как реакция на художественные формы абстрактного экспрессионизма, а также на связанные с ним дискурс, институции и идеологии[1]. Для минимал-арта характерны очищенные от всякого символизма и метафоричности геометрические формы, повторяемость, монохромность, нейтральные поверхности, промышленные материалы и способ изготовления. Минимализм стремится передать упрощённую суть и форму предметов, отсекая вторичные образы и оболочки. Преобладает символика цвета, пятна и линий.',
    background: '0000BB'
  }
]

@annotations = [
  'Супремати́зм — направление в авангардистском искусстве, основанное в 1-й половине 1910-х годов К. С. Малевичем. Являясь разновидностью абстракционизма, супрематизм выражался в комбинациях разноцветных плоскостей простейших геометрических очертаний.',
  'Кубизм (фр.cubisme, от cube – куб) – художественное направление во французском искусстве начала ХХ века, основателями и крупнейшими представителями которого были Пабло Пикассо и Жорж Брак.',
  'Аванга́рд, авангарди́зм — обобщающее название течений в мировом, прежде всего в европейском искусстве, возникших на рубеже XIX и XX веков.',
  'Ми́нимал-арт (англ. Minimal art), также Минимали́зм (англ. Minimalism), Иску́сство ABC (англ. ABC Art) — художественное течение, возникшее в Нью-Йорке в 1960-х годах. В теории искусства обычно рассматривается как реакция на художественные формы абстрактного экспрессионизма, а также на связанные с ним дискурс, институции и идеологии[1]. Для минимал-арта характерны очищенные от всякого символизма и метафоричности геометрические формы, повторяемость, монохромность, нейтральные поверхности,  промышленные материалы и способ изготовления. Минимализм стремится передать упрощённую суть и форму предметов, отсекая вторичные образы и оболочки. Преобладает символика цвета, пятна и линий.'
]

# Fake Data Methods

def random_artist_id
  Artist.offset(rand(Artist.count)).first.id
end

def upload_fake_image
  uploader = ImageUploader.new(Artwork.new, :image)
  uploader.cache!(File.open(Dir.glob(File.join(Rails.root, 'lib/tasks/artworks', '*')).sample))
  uploader
end

def artwork_year
  rand(1850..1950)
end

def random_color
  colour = "%06x" % (rand * 0xffffff)
end

# Create Methods

def create_user(user)
  password = "testtest"
  banned = user[:banned] ? user[:banned] : false

  User.create(
    email:                 user[:email],
    role:                  user[:role],
    banned:                banned,
    password:              password,
    password_confirmation: password
  )
end

def create_artwork
  Artwork.create(
    artist_id: random_artist_id,
    title:     @artwork_titles.sample,
    year:      artwork_year,
    image:     upload_fake_image
  )
end

def create_gallery (gallery)
  Gallery.create(
    title:      gallery[:title],
    teaser:     gallery[:teaser],
    background: random_color
  )
end

def create_artist(artist)
  Artist.create(
  name: artist[:name],
  born: artist[:born],
  died: artist[:died]
  )
end

def create_exhibition(gallery, artwork)
  gallery.exhibitions.create(
    artwork_id: artwork.id
  )
end

def create_annotation(gallery, annotation)
  gallery.annotations.create(
    body: annotation
  )
end

# Seed Database With Fake Data

@users.each do |user|
  u = create_user(user)
  puts "User with email #{u.email} created"
end

@artists.each do |artist|
  a = create_artist(artist)
  puts "Artist #{a.id} created"
end

10.times do
  artwork = create_artwork
  puts "Artwork #{artwork.id} created"
end

@galleries.each do |gallery|
  g = create_gallery(gallery)
  puts "gallery #{g.id} created"
end

@artworks = Artwork.all

Gallery.all.each do |gallery|
  5..20.times do
    e = create_exhibition(gallery, @artworks.sample)

    puts "Gallery #{gallery.id} artwork #{e.artwork_id} exhibition #{e.id} created"
  end

  2..5.times do
    a = create_annotation(gallery, @annotations.sample)
    puts "Gallery #{gallery.id} annotation #{a.id} created"
  end
end

finish = Time.now
duration = finish - start

puts "Task completed in #{duration}"

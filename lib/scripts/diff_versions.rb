file_path1, file_path2 = ARGV[0], ARGV[1]

version1, version2 = [file_path1, file_path2].map { |file_path| File.read(file_path) }

characters1 = version1.split("\n").map { |row| row.split("") }
characters2 = version2.split("\n").map { |row| row.split("") }

(0..28).each do |y|
  row = []

  (0..28).each do |x|
    a, b = characters1[y][x], characters2[y][x]

    char =
      if a == b
        "＿"
      else
        b
      end

    row << char
  end

  puts row.join("")
end

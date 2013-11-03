class Game
    attr_accessor :field
    attr_accessor :width
    attr_accessor :height

    def initialize(width, height, cells)
        @width, @height = width, height
        @field = (0..height).to_a.map { |i| [0] * width}
        @step = 0

        cells.times do
            coords = (0..@height - 1).to_a.product((0..@width - 1).to_a)
            coords.select! { |pair| @field[pair[0]][pair[1]] == 0 }
            pair = coords[rand coords.size]
            @field[pair[0]][pair[1]] = 1
        end
    end

    def step
        alive = []
        dead = []

        coords = (0..@height - 1).to_a.product((0..@width - 1).to_a)

        # only living dead left
        coords.map do |pair|
            if will_live?(pair[0], pair[1])
                # @field[pair[0]][pair[1]] = 1
                alive << pair
            else
                # @field[pair[0]][pair[1]] = 0
                dead << pair
            end
        end

        dead.map do |pair|
            @field[pair[0]][pair[1]] = 0
        end

        alive.map do |pair|
            @field[pair[0]][pair[1]] = 1
        end
    end

    def end?
        not (@field.any? { |row| row.any? { |cell| cell == 1 } })
    end

    def to_s
        @field.map do |row|
            row.map do |cell|
                if cell == 0
                    "."
                else
                    "*"
                end
            end.join " "
        end.join "\n"
    end

    protected

        def will_live?(x, y)
            neighbours = get_neighbours(x, y)

            if (@field[x][y] == 0 and neighbours == 3) or (@field[x][y] == 1 and (neighbours == 2 or neighbours == 3))
                true
            elsif @field[x][y] == 1 and (neighbours > 3 or neighbours < 2)
                false
            else
                false
            end
        end

        def get_neighbours(x, y)
            coords = [
                [x, y - 1],
                [x, y + 1],
                [x - 1, y],
                [x + 1, y],
                [x - 1, y - 1],
                [x - 1, y + 1],
                [x + 1, y - 1],
                [x + 1, y + 1]
            ]

            coords.reject! { |pair| pair[0] < 0 or pair[0] >= width or pair[1] < 0 or pair[1] >= height }

            coords.map! do |pair|
                (@field[pair[0]][pair[1]] == 1) ? 1 : 0
            end

            coords.inject :+
        end
end

g = Game.new(5, 5, 13)

20.times do |i|
    puts "=" * 10
    puts "EPOCH ##{ i }"
    puts "=" * 10

    puts g.to_s

    g.step

    break if g.end?
end
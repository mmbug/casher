module CRX
  module View_helpers

    def keyboard(list, slice = 3)
      buts = []
      list.each_slice(slice) do |slice|
        row = []
        slice.each do |res|
          begin
            line = yield res
            row << line
          rescue => eed
            puts "FALSE CLASS"
            puts eed.message
          end
        end
        buts << row
      end
      buts
    end

    def inline_keyboard(list)
      buts = []
      list.each do |res|
        line = yield res
        buts << [line]
      end
    end

  end
end
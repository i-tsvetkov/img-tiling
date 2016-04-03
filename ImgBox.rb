class ImgBox
  attr_accessor :w, :h

  def diff(img)
    [@w - img.w, @h - img.h].map(&:abs).min
  end

  def scale(k)
    return self if k == 1
    @w *= k
    @h *= k
    self
  end

  def merge(img)
    Div.new(self, img)
  end

  def self.make_tile(imgs)
    imgs = imgs.map{ |i| Img.new(i[:w], i[:h], i[:src]) }
    while imgs.size > 1 do
      i1, i2 = imgs.combination(2).min_by{ |i1, i2| i1.diff(i2) }
      imgs -= [i1, i2]
      imgs.push i1.merge(i2)
    end
    imgs.first.render
  end
end

class Img < ImgBox
  def initialize(w, h, src)
    @w, @h = w, h
    @src = src
  end

  def render
    "<img width=#{@w.round} height=#{@h.round} src=\"#{@src}\">"
  end
end

class Div < ImgBox
  def initialize(fst, snd)
    @fst = fst
    @snd = snd
    @direction = (fst.w - snd.w).abs < (fst.h - snd.h).abs ? :column : :row
    case @direction
    when :column
      @w = [fst.w, snd.w].min
      @h = fst.scale(@w.fdiv fst.w).h + snd.scale(@w.fdiv snd.w).h
    when :row
      @h = [fst.h, snd.h].min
      @w = fst.scale(@h.fdiv fst.h).w + snd.scale(@h.fdiv snd.h).w
    end
  end

  def render
    "<div style=\"display:flex;flex-direction:#{@direction};\">"\
      "#{@fst.render}#{@snd.render}"\
    "</div>"
  end

  def scale(k)
    return self if k == 1
    @fst.scale(k)
    @snd.scale(k)
    super
  end
end


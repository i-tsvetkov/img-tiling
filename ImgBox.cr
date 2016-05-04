abstract class ImgBox
  getter :w, :h

  def diff(img)
    [@w - img.w, @h - img.h].map(&.abs).min
  end

  def scale(k)
    @w *= k
    @h *= k
    self
  end

  def merge(img)
    Div.new(self, img)
  end

  def self.make_tile(imgs)
    imgs = imgs.map{ |i| Img.new(i[:w], i[:h], i[:src]) as ImgBox }
    while imgs.size > 1
      i1, i2 = imgs.combinations(2).min_by{ |ic| ic[0].diff(ic[1]) }
      imgs -= [i1, i2]
      imgs.push i1.merge(i2)
    end
    imgs.first.render
  end

  def self.make_gallery(imgs, width = 512)
    imgs = imgs.map{ |i| Img.new(i[:w], i[:h], i[:src]) as ImgBox }
    results = [] of ImgBox
    while imgs.size > 1
      i1, i2 = imgs.combinations(2).min_by{ |ic| ic[0].diff(ic[1]) }
      imgs -= [i1, i2]
      i = i1.merge(i2)
      if i.w >= width
        results.push i
      else
        imgs.push i
      end
    end
    results.concat imgs
    results.each{ |i| i.scale(width / i.w) }
    results.map(&.render).join
  end
end

class Img < ImgBox
  def initialize(w, h, src)
    @w, @h = w.to_f, h.to_f
    @src = src
  end

  def render
    "<a href=\"#{@src}\" target=_blank>"\
      "<img width=#{@w.round} height=#{@h.round} src=\"#{@src}\">"\
    "</a>"
  end
end

class Div < ImgBox
  def initialize(fst, snd)
    @fst = fst
    @snd = snd
    if (fst.w - snd.w).abs < (fst.h - snd.h).abs
      @direction = :column
      @w = [fst.w, snd.w].min
      @h = fst.scale(@w / fst.w).h + snd.scale(@w / snd.w).h
    else
      @direction = :row
      @h = [fst.h, snd.h].min
      @w = fst.scale(@h / fst.h).w + snd.scale(@h / snd.h).w
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


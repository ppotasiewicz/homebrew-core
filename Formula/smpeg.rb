class Smpeg < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_0_4_5/", :revision => "399"

  bottle do
    cellar :any
    sha256 "cb3025371e326912b67b611c8c199c8ce0691e367b4ecbe676458beb30e23ac9" => :mojave
    sha256 "ff2e2fa327d7bfb2f5a0d370e912865b7936248dda469d1df3a1a31b4bd26924" => :high_sierra
    sha256 "7c4a228fa509d8f55b14ecf64e9c2eecc7a025c1143d983b4bb0efe379699143" => :sierra
    sha256 "a3259cfd8367ab200203429135ada050db88f8fafc58bf601a6ab0539c4292ed" => :el_capitan
    sha256 "b205e203c6942fcf32e16696eeca2e38416b226e9f737ad6b53e21a3130e7fc8" => :yosemite
    sha256 "9230641a8af9ce9c7da7102ea957a764d22185981e123604f81f2260a9f75dcb" => :mavericks
    sha256 "0923b3aae2d9854152ccd50b94a838e590e482d93a2cee4ed010c9810e7dabd7" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "gtk+" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --with-sdl-prefix=#{Formula["sdl"].opt_prefix}
      --disable-dependency-tracking
      --disable-debug
      --disable-sdltest
    ]

    if build.without? "gtk"
      args << "--disable-gtk-player"
      args << "--disable-gtktest"
    end

    # Skip glmovie to avoid OpenGL error
    args << "--disable-opengl-player"

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    # Install script is not +x by default for some reason
    chmod 0755, "./install-sh"
    system "make", "install"

    rm_f "#{man1}/gtv.1" if build.without? "gtk"
  end

  test do
    system "#{bin}/plaympeg", "--version"
  end
end

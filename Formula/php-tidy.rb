class PhpTidy < Formula
  desc "PHP bindings for the Tidy HTML clean and repair utility"
  homepage "https://secure.php.net/manual/en/book.tidy.php"
  url "https://php.net/get/php-7.2.4.tar.xz/from/this/mirror"
  sha256 "7916b1bd148ddfd46d7f8f9a517d4b09cd8a8ad9248734e7c8dd91ef17057a88"

  depends_on "autoconf" => :build
  depends_on "php"
  depends_on "tidy-html5"

  def install
    ENV["PHP_AUTOCONF"] = Formula["autoconf"].opt_bin / "autoconf"
    ENV["PHP_AUTOHEADER"] = Formula["autoconf"].opt_bin / "autoheader"

    Dir.chdir "ext/tidy"

    system "phpize"
    system "./configure", "--prefix=#{prefix}",
                          "--with-tidy=#{Formula["tidy-html5"].opt_prefix}"
    system "make"

    prefix.install "modules/tidy.so"

    configuration_file.write(configuration)
  end

  def configuration_file
    etc / "php" / "7.2" / "conf.d" / "ext-tidy.ini"
  end

  def configuration
    <<~EOS
      [tidy]
      extension=#{opt_prefix}/tidy.so
    EOS
  end

  test do
    assert_match /tidy/, shell_output("php -m")
  end
end

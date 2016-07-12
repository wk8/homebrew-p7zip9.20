class P7zip920 < Formula
  desc "7-Zip (high compression file archiver) implementation, v 9.20"
  homepage "http://p7zip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/9.20/p7zip_9.20_src_all.tar.bz2"
  version "9.20"
  sha256 "62c73bf2bd9be828e173c6eb117228d1c9d7c676bcf77eb7d9901719bc84eb13"
  revision 1

  def install
    mv "makefile.macosx_llvm_64bits", "makefile.machine"

    inreplace "makefile.machine" do |s|
      s.gsub! "CXX=/Developer/usr/bin/llvm-g++ $(ALLFLAGS)", "CXX=g++ $(ALLFLAGS)"
      s.gsub! "CC=/Developer/usr/bin/llvm-gcc $(ALLFLAGS)", "CC=gcc $(ALLFLAGS)"
    end

    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7z", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7z", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", File.read(testpath/"out/foo.txt")
  end
end

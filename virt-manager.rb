class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  url "https://virt-manager.org/download/sources/virt-manager/virt-manager-2.2.1.tar.gz"
  sha256 "cfd88d66e834513e067b4d3501217e21352fadb673103bacb9e646da9f029a1b"
  revision 3

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "gtk-vnc"
  depends_on "gtksourceview4"
  depends_on "hicolor-icon-theme"
  depends_on "libosinfo"
  depends_on "libvirt"
  depends_on "libvirt-glib"
  depends_on "libxml2" # need python3 bindings
  depends_on "osinfo-db"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"
  depends_on "spice-gtk"
  depends_on "vte3"

  resource "libvirt-python" do
    url "https://libvirt.org/sources/python/libvirt-python-7.9.0.tar.gz"
    sha256 "8535cffa5fbf05185648f9f57a2f71899c3bc12c897d320351c53725a48e5359"
  end

  resource "idna" do
    url "https://pypi.io/packages/source/i/idna/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "certifi" do
    url "https://pypi.io/packages/source/c/certifi/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "chardet" do
    url "https://pypi.io/packages/source/c/chardet/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "urllib3" do
    url "https://pypi.io/packages/source/u/urllib3/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "requests" do
    url "https://pypi.io/packages/source/r/requests/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  # virt-manager doesn't prompt for password on macOS unless --no-fork flag is provided
  patch :DATA

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # virt-manager uses distutils, doesn't like --single-version-externally-managed
    system "#{libexec}/bin/python", "setup.py",
                     "configure",
                     "--prefix=#{libexec}"
    system "#{libexec}/bin/python", "setup.py",
                     "--no-user-cfg",
                     "--no-update-icon-cache",
                     "--no-compile-schemas",
                     "install"

    # install virt-manager commands with PATH set to Python virtualenv environment
    bin.install Dir[libexec/"bin/virt-*"]
    bin.env_script_all_files(libexec/"bin", :PATH => "#{libexec}/bin:$PATH")

    share.install Dir[libexec/"share/man"]
    share.install Dir[libexec/"share/glib-2.0"]
    share.install Dir[libexec/"share/icons"]
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    # manual icon cache update step
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/virt-manager", "--version"
  end
end
__END__
diff --git a/virt-manager b/virt-manager
index 15d5109..8ee305a 100755
--- a/virt-manager
+++ b/virt-manager
@@ -151,7 +151,8 @@ def parse_commandline():
         help="Print debug output to stdout (implies --no-fork)",
         default=False)
     parser.add_argument("--no-fork", action="store_true",
-        help="Don't fork into background on startup")
+        help="Don't fork into background on startup",
+        default=True)

     parser.add_argument("--show-domain-creator", action="store_true",
         help="Show 'New VM' wizard")

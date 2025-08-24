require 'json'
require 'fileutils'

class AppGenerator
  def initialize(config_file)
    @config = JSON.parse(File.read(config_file))
  end

  def generate_app
    create_project_structure
    generate_android_project
    generate_ios_project
  end

  private

  def create_project_structure
    FileUtils.mkdir_p(@config['app_name'])
    FileUtils.mkdir_p("#{@config['app_name']}/android")
    FileUtils.mkdir_p("#{@config['app_name']}/ios")
  end

  def generate_android_project
    android_config = @config['android']
    File.open("#{@config['app_name']}/android/#{android_config['package_name']}.java", 'w') do |f|
      f.write("package #{android_config['package_name']};\n\n")
      f.write("public class #{@config['app_name']} {\n")
      f.write("  public static void main(String[] args) {\n")
      f.write("    System.out.println('#{@config['app_name']}');\n")
      f.write("  }\n")
      f.write("}\n")
    end

    File.open("#{@config['app_name']}/android/AndroidManifest.xml", 'w') do |f|
      f.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
      f.write("<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"\n")
      f.write("    package=\"#{android_config['package_name']}\">\n")
      f.write("    <application android:allowBackup=\"true\" android:icon=\"@mipmap/ic_launcher\"\n")
      f.write("        android:label=\"#{@config['app_name']}\">\n")
      f.write("        <activity android:name=\".MainActivity\">\n")
      f.write("            <intent-filter>\n")
      f.write("                <action android:name=\"android.intent.action.MAIN\" />\n")
      f.write("                <category android:name=\"android.intent.category.LAUNCHER\" />\n")
      f.write("            </intent-filter>\n")
      f.write("        </activity>\n")
      f.write("    </application>\n")
      f.write("</manifest>\n")
    end
  end

  def generate_ios_project
    ios_config = @config['ios']
    File.open("#{@config['app_name']}/ios/#{ios_config['target_name']}.swift", 'w') do |f|
      f.write("import UIKit\n\n")
      f.write("class #{@config['app_name']}ViewController: UIViewController {\n")
      f.write("    override func viewDidLoad() {\n")
      f.write("        super.viewDidLoad()\n")
      f.write("        print('#{@config['app_name']}')\n")
      f.write("    }\n")
      f.write("}\n")
    end

    File.open("#{@config['app_name']}/ios/Info.plist", 'w') do |f|
      f.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
      f.write("<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n")
      f.write("<plist version=\"1.0\">\n")
      f.write("    <dict>\n")
      f.write("        <key>CFBundleDevelopmentRegion</key>\n")
      f.write("        <string>en</string>\n")
      f.write("        <key>CFBundleExecutable</key>\n")
      f.write("        <string>#{@config['app_name']}</string>\n")
      f.write("        <key>CFBundleIdentifier</key>\n")
      f.write("        <string>#{@ios_config['bundle_id']}</string>\n")
      f.write("        <key>CFBundleInfoDictionaryVersion</key>\n")
      f.write("        <string>6.0</string>\n")
      f.write("        <key>CFBundleName</key>\n")
      f.write("        <string>#{@config['app_name']}</string>\n")
      f.write("        <key>CFBundlePackageType</key>\n")
      f.write("        <string>APPL</string>\n")
      f.write("        <key>CFBundleShortVersionString</key>\n")
      f.write("        <string>1.0</string>\n")
      f.write("        <key>CFBundleVersion</key>\n")
      f.write("        <string>1</string>\n")
      f.write("    </dict>\n")
      f.write("</plist>\n")
    end
  end
end

generator = AppGenerator.new('config.json')
generator.generate_app
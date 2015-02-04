Pod::Spec.new do |s|
s.name     = 'SQLitePersistentObject'
s.version  = '0.1'
s.license  = 'MIT'
s.summary  = 'An ORM kit of object persistence use SQLite'
s.homepage = 'https://github.com/openboy2012/DDSQLiteKit.git'
s.author   = { 'Jeff LaMarche' => 'jeff_Lamarche@mac.com' }
s.source   = { :git => 'https://github.com/openboy2012/DDSQLiteKit.git', :tag => '0.1' }
s.ios.deployment_target = '5.1.1'
s.osx.deployment_target ＝ '10.7'
s.source_files = 'DDSQLiteKit/SQLitePersistentObject/*.{h,m}'
s.requires_arc = true
s.frameworks = 'UIKit'
end


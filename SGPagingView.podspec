
Pod::Spec.new do |s|
    s.name         = 'SGPagingView'
    s.version      = '1.6.7'
    s.summary      = 'A powerful and easy to use segment control'
    s.homepage     = 'https://github.com/kingsic/SGPagingView'
    s.license      = 'MIT'
    s.authors      = {'kingsic' => 'kingsic@126.com'}
    s.platform     = :ios, '7.0'
    s.source       = {:git => 'https://github.com/kingsic/SGPagingView.git', :tag => s.version}
    s.source_files = 'SGPagingView/**/*.{h,m}'
    s.requires_arc = true
end

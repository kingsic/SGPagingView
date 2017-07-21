
Pod::Spec.new do |s|
    s.name         = 'SGPagingView'
    s.version      = '1.1.6'
    s.summary      = 'An easy-to-use segmented control'
    s.homepage     = 'https://github.com/kingsic/SGPageView'
    s.license      = 'MIT'
    s.authors      = {'kingsic' => 'kingsic@126.com'}
    s.platform     = :ios, '7.0'
    s.source       = {:git => 'https://github.com/kingsic/SGPageView.git', :tag => s.version}
    s.source_files = 'SGPagingView'
    s.requires_arc = true
end

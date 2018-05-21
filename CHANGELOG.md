# CHANGELOG

The changelog for `SGPagingView`.

1.4.0
-----
### Enhancements
- add `(CGFloat)titleViewWidth` to `SGPageTitleView`, for the time init frame not equal to final frame (autolayout with changed layout).
- add `(CGFloat)buttonPaddingX` to `SGPageTitleView`, padding x-axis for `SGPageTitleView` -> `UIButton`, for the case init frame not equal to final frame.
- add `(CGFloat)collectionViewWidth` to `SGPageContentView`, for the time init frame not equal to final frame.

### Bug Fixing
- fixed `(BOOL)isShowBottomSeparator` in `SGPageTitleView`, when init without using `initWithFrame:delegate:titleNames:configure:`.
- fixed scrolling titleview not scrolling when title button array width > container width.

### Changes On Package
- added dependency library `Masonry` to this project, for a better support autolayut feature.s

1.3.9
-----
### Bug Fixing
- fixed `prefetchDataSource` not found in iOS 9 issue, added `@available(iOS 10.0, *)`.

1.3.8
-----
### Bug Fixing
- fixed elastic height bugs.

1.3.7
-----
### Enhancements
- added `elasticHeight` to `SGPageTitleViewConfigure`, to support dynamic height on titleview

1.3.6 and before
-----
### Break Changes
there is a break changes from original repo to this repo

### Enhancements
- added basic autolayout support
- changed inner library by using `NSAttributedString` instead of set text directly to `UIButton` for `SGPageTitleView`
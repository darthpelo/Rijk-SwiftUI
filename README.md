# iOS 14 widgets demo

Playground project created to learn and share how URLSession works with iOS 14 new widget.

## How to Run

If you try to build the project after the checkout, you will have a compiler error due a missing file into *Shared* folder.
The file name is Preferences.plist and I use to share the private key for the [Rijksmuseum open api](https://data.rijksmuseum.nl/):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>key</key>
	<string>secretAPI</string>
</dict>
</plist>
```

So to build the project you need to add the file with your key, that you can get creating an account from [Rijks Studio](https://www.rijksmuseum.nl/nl/rijksstudio). Of course you can change the Moja service to use anoter API as source :)

## Credits

Big thanks to:

- [Bruno Rocha](https://github.com/rockbruno) for his [article](https://swiftrocks.com/ios-14-widget-tutorial-mini-apps)
- Anupam Chugh for the [ispiration](https://medium.com/better-programming/introducing-ios-14-widgetkit-with-swiftui-a9cc473caa24)
- Gualtiero Frigerio for his good article about [remote images in SwiftUI](https://dev.to/gualtierofr/remote-images-in-swiftui-49jp)

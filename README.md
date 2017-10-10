# Asset Caching
This framework aims to provide an easy way to retrieve and cache data files from provided url.

## Installation

Available in iOS 9.0 and later.



Run Terminal

- Navigate to project folder
- Use command:

``` code
echo git \"https://github.com/3pillarlabs/iOS-AssetsCaching.git\" \"master\" > Cartfile
```

- Run carthage by using command:

``` code
carthage update --no-use-binaries --platform iOS
```
- Add the AssetCaching.framework and Reachability.framework to the list of 'Embedded Binaries' (located inside Xcode -> Target -> General tab) from Carthage/Build/iOS in project folder

## Usage

- Import the framework and you are set

``` swift
import AssetCaching
```
- Demo usage code:

``` swift
import UIKit
import AssetCaching

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	let assetManager: AssetManager = AssetManager()

	override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://oceanservice.noaa.gov/facts/sealevel-global-local.jpg"
        if let url = URL(string: urlString) {
            if let asset = Asset(networkURL: url) {
                assetManager.fetchAsset(asset, completion: {[weak self] (asset, error) in
                    if let url = asset.localURL, let image = UIImage(contentsOfFile: url.path) {
                        //Load the asset inside an image view
                        print(image.debugDescription)
                        self?.imageView.image = image
                    }
                })
            }
        }
    }
}
```
## Demo appplication 
For a light demonstration check out "DemoApp" branch to observe functionality.
```git checkout DemoApp```


## License

**Asset Caching** is released under MIT license. See [LICENSE](LICENSE) for details.

## About this project

[![3Pillar Global](https://www.3pillarglobal.com/wp-content/themes/base/library/images/logo_3pg.png)](http://www.3pillarglobal.com/)

**Asset Caching** is developed and maintained by [3Pillar Global](http://www.3pillarglobal.com/).


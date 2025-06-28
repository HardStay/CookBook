import SwiftUI
import GoogleMobileAds
import UIKit

class InterstitialAd: NSObject, GADFullScreenContentDelegate, ObservableObject {
    private var interstitial: GADInterstitialAd?
    @Published var isAdLoaded = false

    override init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        let request = GADRequest()
        print("[InterstitialAd] Loading interstitial ad...")
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", // Test ad unit
                              request: request) { [weak self] ad, error in
            if let ad = ad {
                print("[InterstitialAd] Interstitial ad loaded!")
                self?.interstitial = ad
                self?.interstitial?.fullScreenContentDelegate = self
                self?.isAdLoaded = true
            } else {
                print("[InterstitialAd] Failed to load interstitial ad: \(error?.localizedDescription ?? "Unknown error")")
                self?.isAdLoaded = false
            }
        }
    }

    func showAd(from root: UIViewController) {
        print("[InterstitialAd] Attempting to show interstitial ad. isAdLoaded: \(isAdLoaded)")
        if let ad = interstitial {
            ad.present(fromRootViewController: root)
            isAdLoaded = false
        } else {
            print("[InterstitialAd] Ad wasn't ready")
        }
    }

    // Reload ad after dismissal
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[InterstitialAd] Ad dismissed, reloading...")
        loadAd()
    }
} 

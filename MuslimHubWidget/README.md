# MuslimHub Widget Extension

This folder contains the **static widget** and **Live Activity** for prayer progress (Lock Screen + Dynamic Island).

## Why don’t I see the Live Activity?

The Live Activity only appears if the **Widget Extension target is added** to the project. The main app can start the activity, but iOS needs the extension to draw it on the Lock Screen and in the Dynamic Island.

## Add the Widget Extension in Xcode

1. **Create the target**  
   **File → New → Target → Widget Extension**  
   - Product Name: `MuslimHubWidget`  
   - **Check “Include Live Activity”**  
   - Uncheck “Include Configuration App Intent” (optional)  
   - Finish. When asked “Activate MuslimHubWidget scheme?”, choose **Cancel** (keep running the main app).

2. **Replace the generated code with this extension**  
   - In the Project Navigator, open the **MuslimHubWidget** group created by Xcode.  
   - Delete the Swift file(s) Xcode added (e.g. `MuslimHubWidget.swift`).  
   - Right‑click the **MuslimHub** project → **Add Files to "MuslimHub"** → select the **MuslimHubWidget** folder (the one that contains `MuslimHubWidget.swift`, `PrayerProgressAttributes.swift`, `WidgetShared.swift`).  
   - Check **“Copy items if needed”** and **“Add to targets: MuslimHubWidget”**.  
   - Click Add.

3. **App Group (required)**  
   - Select the **MuslimHub** app target → **Signing & Capabilities** → **+ Capability** → **App Groups** → add `group.com.Areeb.MuslimHub`.  
   - Select the **MuslimHubWidget** extension target → same steps → add the same App Group: `group.com.Areeb.MuslimHub`.

4. **Deployment target**  
   Select **MuslimHubWidget** target → **General** → set **Minimum Deployments** to **iOS 16.2** or later.

5. **Run the app**  
   Run the **MuslimHub** scheme (main app). Open the **Prayer** tab at least once, then lock the device. You should see the Live Activity under the time on the Lock Screen and in the Dynamic Island (on supported devices).

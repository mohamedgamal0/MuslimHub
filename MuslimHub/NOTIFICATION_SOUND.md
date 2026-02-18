# Prayer notification sound (Adhan)

For the Adhan to play with prayer-time notifications, add a sound file named **`adhanNotification`** to the app.

## Requirements (iOS)

- **Format:** `.caf`, `.wav`, or `.aiff`. **The audio codec must be Linear PCM or IMA4** — iOS ignores other codecs (e.g. AAC/MP3 inside a .caf) and plays the default sound instead.
- **Length:** 30 seconds or less.
- **Location:** In the MuslimHub app target (File Inspector → **Target Membership** → MuslimHub checked).

## Notification shows but no custom sound?

1. **In the app:** Open **Settings** and scroll to the Notifications section. Under the Test button you’ll see either:
   - **"Custom Adhan sound: found"** → The file is in the bundle. If you still hear the default sound, the **audio codec** is wrong. Re-convert with the exact command below.
   - **"Custom Adhan: not found"** → The file isn’t in the app bundle. Add `adhanNotification.caf` to the project and ensure **Target Membership → MuslimHub** is checked, then rebuild.

2. **Re-convert with the correct codec (recommended):**  
   Use this exact command so iOS accepts the sound (Linear PCM, 16-bit, 44.1 kHz, mono):

   ```bash
   afconvert -f caff -d LEI16@44100 -c 1 input.wav adhanNotification.caf
   ```

   From MP3 (convert to WAV first, or try):

   ```bash
   afconvert -f caff -d LEI16@44100 -c 1 your_adhan.mp3 adhanNotification.caf
   ```

3. **Add to Xcode:** Drag `adhanNotification.caf` into the MuslimHub group, ensure **Copy items if needed** and **MuslimHub** target are checked. Clean build (Product → Clean Build Folder) and run again.

## Other checks

- **Ringer:** Device must not be in Silent mode (side switch). In Silent mode, notification sounds are muted unless you use Critical Alerts.
- **App in background:** Send the app to the background or lock the device, then use **Test Adhan notification** — sound often doesn’t play when the app is in the foreground.
- **System settings:** **Settings → Notifications → MuslimHub** → **Sounds** ON, **Allow Notifications** ON.

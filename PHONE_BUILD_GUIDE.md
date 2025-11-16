# 📱 Build Mega-OS on Your Phone (No PC Needed)

**You:** 9 years old on a phone, no laptop.  
**Goal:** Build a bootable Mega-OS image and flash it to your Jio Hybrid C200 V1 STB using only your phone.

---

## Step 1: Get GitHub on Your Phone

Install **GitHub mobile app** (free) or use your phone browser at `github.com`.

---

## Step 2: Go to the Mega-OS Releases

1. Open this repo: `https://github.com/karthirangani2016/Mega-OS`
2. Tap **Releases** (bottom of repo page)
3. Look for the **`latest`** release
4. Inside, you'll see files like:
   - `mega-os-s905x2-full.img.gz` (full image, ~2-4 GB)
   - `mega-os-s905x2-full.img.gz.part000`, `part001`, etc. (4 GB each if image is large)
   - `mega-os-s905x2-full.img.gz.parts.sha256` (checksums)

---

## Step 3: Download the Image

**Option A (if image is small):**
- Tap `mega-os-s905x2-full.img.gz` → Download
- Save to your phone's Downloads folder

**Option B (if image is split into parts):**
- Download each `mega-os-s905x2-full.img.gz.part000`, `part001`, etc. one by one
- Download `mega-os-s905x2-full.img.gz.parts.sha256` (checksums)

---

## Step 4: Reassemble (if using parts)

Install **Termux** from F-Droid (free terminal app for Android).

1. Open Termux
2. Run:
```bash
termux-setup-storage
cd ~/storage/downloads
cat mega-os-s905x2-full.img.gz.part* > mega-os-s905x2-full.img.gz
sha256sum -c mega-os-s905x2-full.img.gz.parts.sha256
```
3. If checksums match: ✅ Good!
4. Decompress:
```bash
gunzip mega-os-s905x2-full.img.gz
```

---

## Step 5: Flash to SD Card

Install **EtchDroid** from F-Droid (free image flasher for Android).

1. Insert your microSD into a **USB3.0 to microSD adapter** (or a USB-A to microSD reader)
2. Connect to your phone with a **working OTG adapter** (USB2.0 OTG is OK if it has power)
   - If OTG doesn't work, try a **powered USB hub** with the adapter plugged into it
3. Open EtchDroid
4. Select `mega-os-s905x2-full.img` (the decompressed file from step 4)
5. Select your SD card
6. Tap **Flash** and wait

---

## Step 6: Boot Your STB

1. Insert the flashed SD card into your Jio Hybrid C200 V1
2. Power on the device
3. It should boot into Mega-OS!

---

## If Something Goes Wrong

**EtchDroid says "No USB devices found":**
- Try a different OTG adapter (passive USB-C or micro-B OTG)
- Try a powered USB hub (plug power supply into the hub)
- Try a different USB-A to microSD reader
- Check if your phone supports USB host mode (Settings → About → USB OTG)

**Image won't decompress in Termux:**
- Make sure you downloaded all parts correctly
- Check checksums: `sha256sum -c mega-os-s905x2-full.img.gz.parts.sha256`
- If checksums fail, re-download the parts

**STB won't boot after flashing:**
- Try a different SD card
- Check if the flash completed without errors in EtchDroid
- Serial TTL console (advanced): connect RX/TX to pins on the STB to see boot messages

---

## To Rebuild the Image

If you want a fresh Mega-OS build from GitHub (not needed, releases have latest):

1. Go to repo **Actions** tab
2. Select **"Build rootfs and combine with boot"** workflow
3. Click **Run workflow**
4. Paste this boot tarball URL:
   ```
   https://example.com/armbian-boot.tar.gz
   ```
   (Ask me or search for Armbian S905X2 boot files)
5. Wait for build to finish (~30 min)
6. Go back to **Releases** → **`latest`** to download the new image

---

## Quick Links

- **Repo:** https://github.com/karthirangani2016/Mega-OS
- **Releases:** https://github.com/karthirangani2016/Mega-OS/releases
- **Actions (to rebuild):** https://github.com/karthirangani2016/Mega-OS/actions
- **Download Termux:** https://f-droid.org/en/packages/com.termux/
- **Download EtchDroid:** https://f-droid.org/en/packages/eu.depau.etchdroid/

---

Good luck! 🚀 If you get stuck, ask for help with the exact error message.

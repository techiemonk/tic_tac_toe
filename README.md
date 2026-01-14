Markdown

# ⭕❌ Tic Tac Toe

A sleek, Cyberpunk-styled Tic Tac Toe game built with **Flutter**.  
This isn't just standard Tic Tac Toe—it features **Infinite Game Logic**, a **Smart AI**, and satisfying **Neon/Glassmorphism** visuals.


## ✨ Features

* **🎨 Neon Dark Mode UI:** Deep navy background with glowing gradients and glassmorphism effects.
* **🔄 Infinite Logic:** Pieces don't stay forever! Each player can only have **3 marks** on the board. When you place the 4th, your oldest mark disappears. This prevents draws and keeps the game dynamic.
* **🤖 Single Player AI:** Play against a "Medium Difficulty" computer that knows how to win and block your moves.
* **👥 Two Player Mode:** Classic hot-seat multiplayer.
* **🔊 Sound Effects:** Satisfying "Pop" sounds with a Mute toggle in settings.
* **⚙️ Settings Menu:** Toggle game modes and sound effects easily.



## 🎮 How to Play

1.  **Objective:** Get 3 of your marks in a row (Horizontal, Vertical, or Diagonal).
2.  **The Twist:** You only have **3 moves** on the board at a time.
    * Move 1, 2, 3: Normal placement.
    * **Move 4:** Your 1st mark **disappears**!
    * **Move 5:** Your 2nd mark **disappears**!
3.  **Winning:** You must plan ahead to align 3 marks before they fade away.

## 🛠️ Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** `setState` (Clean & Simple)
* **Audio:** [`audioplayers`](https://pub.dev/packages/audioplayers) package
* **Icons:** Cupertino & Material Icons

## 🚀 Installation & Setup

If you want to build this project locally:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/techiemonk/tic_tac_toe_neon.git](https://github.com/techiemonk/tic_tac_toe_neon.git)
    cd tic_tac_toe_neon
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the App:**
    ```bash
    flutter run
    ```

4.  **Build APK (Release):**
    ```bash
    flutter build apk --split-per-abi --release
    ```

## 📂 Project Structure

```text
lib/
└── main.dart         # The entire game logic and UI (Single File Architecture)
assets/
├── icon.png          # App Icon
└── pop.mp3           # Sound Effect
pubspec.yaml          # Dependencies & Asset registration
```
📥 Download
You can download the latest APK directly from Itch.io: 👉 Download on Itch.io

🤝 Contributing
Contributions are welcome! If you have ideas for Hard Mode AI or Online Multiplayer, feel free to fork the repo and submit a Pull Request.

Fork the Project

Create your Feature Branch (git checkout -b feature/NewFeature)

Commit your Changes (git commit -m 'Add some NewFeature')

Push to the Branch (git push origin feature/NewFeature)

Open a Pull Request

📄 License
Distributed under the MIT License. See LICENSE for more information.

Created with ❤️ by @techiemonk

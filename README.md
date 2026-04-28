# ⚙️ Dotfiles

Personal Zsh, Git, and shell configuration managed with symlinks.

---

## ✨ Features

- Zsh configuration (`.zshrc`)
- Powerlevel10k prompt (`.p10k.zsh`)
- Git config (`.gitconfig`)
- Custom aliases and functions
- Simple install script
- Automatic backups of existing configs

---

## 🚀 Installation

### 🔹 Option 1: Quick install (recommended)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sheepdog-97/dotfiles/main/install.sh)"
```

---

### 🔹 Option 2: Manual install

```bash
git clone https://github.com/sheepdog-97/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

---

## 🗑 Uninstall

```bash
cd ~/dotfiles
bash uninstall.sh
```

## 📦 What the install script does

- Clones the repo to `~/dotfiles`
- Backs up existing config files to `~/.old-dotfiles`
- Creates symlinks in your home directory

---

## 🔗 How it works

This setup uses **symbolic links**.

Your actual files live here:

```bash
~/dotfiles
```

Your home directory files point to them:

```bash
~/.zshrc → ~/dotfiles/.zshrc
~/.gitconfig → ~/dotfiles/.gitconfig
```

### ✅ Benefits

- Single source of truth for configs  
- Easy to update across machines  
- Fully version controlled  

---

## ⚠️ Important

- Do **not delete** `~/dotfiles` — your system depends on it  
- Existing files are **moved**, not deleted  
- Backups are stored in:

```bash
~/.old-dotfiles
```

---

## 🔄 Updating

To pull the latest changes:

```bash
cd ~/dotfiles
git pull
```

Then reload your shell:

```bash
source ~/.zshrc
```

---

## 🧰 Requirements

Make sure you have:

- `git`
- `zsh`
- [Oh My Zsh](https://ohmyz.sh/)
- (Optional) [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

---

## 🛠 Customization

Edit any file inside:

```bash
~/dotfiles
```

Common files:

- `aliases.zsh`
- `functions.zsh`
- `.zshrc`

---

## 🧯 Troubleshooting

### Oh My Zsh not installed

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

## 📁 Structure

```bash
dotfiles/
├── .zshrc
├── .p10k.zsh
├── .gitconfig
├── aliases.zsh
└── functions.zsh
```

---

## 📜 License

MIT (or whatever you prefer)

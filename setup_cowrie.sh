#!/bin/bash

# ==============================
# Cowrie Honeypot Setup (Fedora)
# ==============================

echo "[+] Updating system..."
sudo dnf update -y

echo "[+] Installing dependencies..."
sudo dnf install -y git python3 python3-pip python3-virtualenv \
python3-devel openssl-devel libffi-devel gcc make authbind iptables

# ------------------------------
# Create user
# ------------------------------
echo "[+] Creating cowrie user..."
sudo useradd -m -s /bin/bash cowrie 2>/dev/null

echo "[!] Set password manually:"
echo "sudo passwd cowrie"

# ------------------------------
# Switch user
# ------------------------------
echo "[+] Switching to cowrie user..."
sudo su - cowrie << 'EOF'

echo "[+] Cloning Cowrie..."
git clone https://github.com/cowrie/cowrie
cd cowrie

echo "[+] Creating virtual environment..."
python3 -m venv cowrie-env

echo "[+] Activating environment..."
source cowrie-env/bin/activate

echo "[+] Installing Cowrie..."
python -m pip install --upgrade pip
python -m pip install -e .

echo "[+] Creating config file..."
cp etc/cowrie.cfg.dist etc/cowrie.cfg

echo "[+] Enabling Telnet..."
echo "[telnet]" >> etc/cowrie.cfg
echo "enabled = true" >> etc/cowrie.cfg

echo "[+] Starting Cowrie..."
cowrie start

echo "[+] Cowrie started on port 2222"

EOF

# ------------------------------
# Port Redirection
# ------------------------------
echo "[+] Redirecting port 22 -> 2222..."
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222

echo "[+] Done!"
echo "Use: sudo iptables -t nat -L -n to verify"

# 🍯 Cowrie Honeypot Lab (Fedora)

<p align="center">
  <img src="https://img.shields.io/badge/Cybersecurity-Honeypot-blue?style=for-the-badge&logo=shield&logoColor=white" alt="Cybersecurity">
  <img src="https://img.shields.io/badge/Tool-Cowrie-black?style=for-the-badge&logo=linux&logoColor=white" alt="Cowrie">
  <img src="https://img.shields.io/badge/Platform-Fedora-294172?style=for-the-badge&logo=fedora&logoColor=white" alt="Fedora">
  <img src="https://img.shields.io/badge/Logs-JSON-green?style=for-the-badge&logo=json&logoColor=white" alt="JSON">
  <img src="https://img.shields.io/badge/Status-Active-success?style=for-the-badge&logo=checkmarx&logoColor=white" alt="Active">
</p>

<p align="center">
  <b>A production-ready SSH/Telnet honeypot deployment for cybersecurity research and threat intelligence</b>
</p>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Why This Project?](#why-this-project)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Installation](#detailed-installation)
- [Configuration](#configuration)
- [Running the Honeypot](#running-the-honeypot)
- [Port Redirection](#port-redirection)
- [Logs & Monitoring](#logs--monitoring)
- [Log Analysis](#log-analysis)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Resources](#resources)
- [Disclaimer](#disclaimer)

---

## 🔍 Overview

This project deploys a **Cowrie SSH/Telnet Honeypot on Fedora** to simulate real-world cyberattacks and capture attacker behavior in a controlled, isolated environment.

### ✨ Key Features

| Feature | Description |
|---------|-------------|
| 📝 **Real-time Logging** | Capture every interaction with millisecond precision |
| 🔄 **Port Redirection** | Seamlessly redirect SSH traffic (22 → 2222) |
| 🎯 **Attack Simulation** | Test using Kali Linux or other penetration testing tools |
| 🤖 **AI-Ready Data** | Structured JSON logs perfect for ML/LLM analysis |
| 🔒 **Safe Environment** | Isolated sandbox that protects your real infrastructure |
| 📊 **Rich Telemetry** | Commands, files, credentials, and network activity |

---

## 🎯 Why This Project?

Cyber attackers constantly scan the internet for vulnerable SSH services. According to [Shodan](https://www.shodan.io), millions of SSH servers are exposed to the internet daily.

### What You'll Learn

- 🔍 **Threat Intelligence** - Observe real attacker techniques and TTPs
- 📜 **Forensic Analysis** - Capture and analyze malicious command sequences
- 📈 **Pattern Recognition** - Identify intrusion patterns and attack campaigns
- 🤖 **AI Development** - Build ML models for automated threat detection
- 🛡️ **Defense Strategies** - Understand attacks to build better defenses

### Use Cases

- 🎓 **Education** - Learn about attack methodologies hands-on
- 🔬 **Research** - Study botnet behavior and malware distribution
- 🏢 **Enterprise** - Enhance threat detection capabilities
- 📰 **Intelligence** - Gather IOCs (Indicators of Compromise)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        NETWORK DIAGRAM                          │
└─────────────────────────────────────────────────────────────────┘

    ┌──────────────┐
    │  Internet    │
    │  Attackers   │
    └──────┬───────┘
           │ SSH Port 22
           ▼
    ┌──────────────────┐
    │  Fedora Server   │
    │  ┌────────────┐  │
    │  │  iptables  │  │ ◄── Port Redirection (22 → 2222)
    │  │   NAT/     │  │
    │  │ REDIRECT   │  │
    │  └─────┬──────┘  │
    │        │         │
    │  ┌─────▼──────┐  │
    │  │   Cowrie   │  │ ◄── Honeypot (Port 2222)
    │  │  Honeypot  │  │
    │  │  (Fake SSH)│  │
    │  └─────┬──────┘  │
    │        │         │
    │  ┌─────▼──────┐  │
    │  │  JSON Logs │  │ ◄── ~/cowrie/var/log/cowrie/
    │  │  & SQLite  │  │
    │  └────────────┘  │
    └──────────────────┘
           │
           ▼
    ┌──────────────┐
    │ Kali Linux   │ ◄── Testing/Attack Simulation
    │ (Attacker VM)│
    └──────────────┘
```

### Data Flow

1. **Attacker** scans for open SSH ports (22)
2. **iptables** redirects traffic to Cowrie (2222)
3. **Cowrie** emulates a vulnerable SSH server
4. **Logs** capture all interactions in JSON format
5. **Analysis** tools process the data for insights

---

## 📦 Prerequisites

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Fedora 36+ | Fedora 39+ |
| RAM | 2 GB | 4 GB |
| Disk | 10 GB | 50 GB+ (for logs) |
| Network | Internet access | Public IP (for real attacks) |

### Required Packages

```bash
# Update system
sudo dnf update -y

# Install dependencies
sudo dnf install -y git python3 python3-pip python3-virtualenv \
    python3-devel openssl-devel libffi-devel gcc \
    iptables-services jq
```

### Optional Tools

```bash
# For log analysis
sudo dnf install -y jq elinks

# For visualization
pip3 install cowrie-logviewer
```

---

## 🚀 Quick Start

Get up and running in under 5 minutes:

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/cowrie-honeypot-lab.git
cd cowrie-honeypot-lab

# 2. Make the setup script executable
chmod +x setup_cowrie.sh

# 3. Run the automated setup
./setup_cowrie.sh

# 4. Configure port redirection
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222

# 5. Start the honeypot
cd ~/cowrie
source cowrie-env/bin/activate
cowrie start

# 6. Monitor logs
tail -f ~/cowrie/var/log/cowrie/cowrie.json | jq
```

---

## 🔧 Detailed Installation

### Step 1: Create Cowrie User (Recommended)

```bash
# Create a dedicated user for security
sudo useradd -r -s /bin/bash cowrie
sudo mkdir -p /home/cowrie
sudo chown cowrie:cowrie /home/cowrie

# Switch to cowrie user
sudo su - cowrie
```

### Step 2: Clone Cowrie Repository

```bash
# Clone the official Cowrie repository
cd ~
git clone https://github.com/cowrie/cowrie.git
cd cowrie
```

### Step 3: Set Up Python Virtual Environment

```bash
# Create virtual environment
python3 -m venv cowrie-env

# Activate environment
source cowrie-env/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install requirements
pip install -r requirements.txt
```

### Step 4: Configure Cowrie

```bash
# Copy default configuration
cp etc/cowrie.cfg.dist etc/cowrie.cfg

# Edit configuration
nano etc/cowrie.cfg
```

**Key Configuration Options:**

```ini
[honeypot]
# Hostname shown to attackers
hostname = production-server-01

# Fake SSH version
ssh_version = OpenSSH_8.0

# Enable Telnet (optional)
enabled_telnet = true

[output_json]
# Enable JSON logging
enabled = true
logfile = ${honeypot:log_path}/cowrie.json

[output_sqlite]
# Enable SQLite for easy querying
enabled = true
file = ${honeypot:log_path}/cowrie.db
```

### Step 5: Set Up Port Redirection

```bash
# Make iptables rules persistent
sudo systemctl enable iptables

# Add redirection rule
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222

# Save rules (Fedora)
sudo service iptables save

# Verify rules
sudo iptables -t nat -L PREROUTING -n -v
```

---

## ⚙️ Configuration

### Customizing the Honeypot

#### Fake Filesystem

Create a realistic environment:

```bash
# Edit filesystem layout
nano share/cowrie/fs.pickle

# Or use the custom fs creation tool
cd utils
python3 createfs.py /path/to/real/server > newfs.pickle
```

#### Fake Credentials

Set up tempting login combinations:

```bash
# Edit user database
nano etc/userdb.txt

# Format: username:password:x:uid:gid:description
root:toor:x:0:0:root:/root:/bin/bash
admin:password123:x:1000:1000:admin:/home/admin:/bin/bash
```

#### Custom Commands

Add fake commands that attackers expect:

```bash
# Create custom command handler
mkdir -p honeyfs/bin
echo '#!/bin/bash
echo "CPU: 95%"' > honeyfs/bin/top
chmod +x honeyfs/bin/top
```

---

## ▶️ Running the Honeypot

### Start Cowrie

```bash
cd ~/cowrie
source cowrie-env/bin/activate

# Start in foreground (for debugging)
cowrie start --foreground

# Start in background (production)
cowrie start

# Check status
cowrie status
```

### Stop Cowrie

```bash
# Graceful shutdown
cowrie stop

# Force stop
cowrie stop --force
```

### Restart Cowrie

```bash
cowrie restart
```

### Auto-Start on Boot

Create a systemd service:

```bash
sudo tee /etc/systemd/system/cowrie.service > /dev/null <<EOF
[Unit]
Description=Cowrie SSH/Telnet Honeypot
After=network.target

[Service]
Type=forking
User=cowrie
Group=cowrie
WorkingDirectory=/home/cowrie/cowrie
ExecStart=/home/cowrie/cowrie/cowrie-env/bin/cowrie start
ExecStop=/home/cowrie/cowrie/cowrie-env/bin/cowrie stop
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable cowrie
sudo systemctl start cowrie
```

---

## 🔄 Port Redirection

### Setup iptables Rules

```bash
# Redirect port 22 to Cowrie (2222)
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222

# For IPv6
sudo ip6tables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
```

### Verify Redirection

```bash
# List NAT rules
sudo iptables -t nat -L PREROUTING -n --line-numbers

# Test from another machine
ssh -p 22 your-honeypot-ip
```

### Remove Redirection (if needed)

```bash
# List rules with line numbers
sudo iptables -t nat -L PREROUTING -n --line-numbers

# Delete specific rule
sudo iptables -t nat -D PREROUTING <line-number>
```

### Persist Rules

```bash
# Install iptables-services
sudo dnf install -y iptables-services

# Save rules
sudo service iptables save

# Or manually
sudo iptables-save > /etc/sysconfig/iptables
```

---

## 📊 Logs & Monitoring

### Log Locations

| Log Type | Location | Format |
|----------|----------|--------|
| JSON Events | `~/cowrie/var/log/cowrie/cowrie.json` | JSON |
| Text Log | `~/cowrie/var/log/cowrie/cowrie.log` | Text |
| SQLite DB | `~/cowrie/var/log/cowrie/cowrie.db` | SQLite |
| Downloads | `~/cowrie/var/lib/cowrie/downloads/` | Binary |

### Real-Time Monitoring

```bash
# Watch JSON logs in real-time
tail -f ~/cowrie/var/log/cowrie/cowrie.json | jq

# Pretty-print with color
tail -f ~/cowrie/var/log/cowrie/cowrie.json | jq -C '. | {timestamp: .timestamp, src_ip: .src_ip, eventid: .eventid}'

# Filter specific events
tail -f ~/cowrie/var/log/cowrie/cowrie.json | jq 'select(.eventid == "cowrie.login.success")'
```

### Log Rotation

Prevent disk space issues:

```bash
# Add to crontab
crontab -e

# Add line for daily rotation
0 0 * * * /home/cowrie/cowrie/bin/cowrie-logrotate
```

---

## 🔍 Log Analysis

### Captured Data

Cowrie captures comprehensive attack data:

| Data Type | Description | Example |
|-----------|-------------|---------|
| 🌐 **Source IP** | Attacker's IP address | 192.168.1.100 |
| 🔑 **Login Attempts** | Username/password tries | root/password123 |
| 💻 **Commands** | Shell commands executed | `cat /etc/passwd` |
| 📥 **Downloads** | Files downloaded by attackers | malware.sh |
| ⏱️ **Session Duration** | Time spent in honeypot | 45 seconds |
| 📡 **Network Activity** | Outbound connections | C2 callbacks |

### Analysis Examples

#### Count Login Attempts

```bash
# Total login attempts
cat ~/cowrie/var/log/cowrie/cowrie.json | jq -r 'select(.eventid == "cowrie.login.failed") | .src_ip' | wc -l

# Unique attacker IPs
cat ~/cowrie/var/log/cowrie/cowrie.json | jq -r 'select(.eventid == "cowrie.login.failed") | .src_ip' | sort -u

# Top attacker IPs
cat ~/cowrie/var/log/cowrie/cowrie.json | jq -r 'select(.eventid == "cowrie.login.failed") | .src_ip' | sort | uniq -c | sort -rn | head -20
```

#### Analyze Commands

```bash
# Most common commands
cat ~/cowrie/var/log/cowrie/cowrie.json | jq -r 'select(.eventid == "cowrie.command.input") | .input' | sort | uniq -c | sort -rn | head -20

# Search for specific commands
cat ~/cowrie/var/log/cowrie/cowrie.json | jq 'select(.input | contains("wget"))'

# Extract downloaded URLs
cat ~/cowrie/var/log/cowrie/cowrie.json | jq -r 'select(.eventid == "cowrie.command.input") | .input' | grep -oE 'https?://[^ ]+' | sort -u
```

#### Generate Reports

```bash
# Daily summary report
#!/bin/bash
LOGFILE=~/cowrie/var/log/cowrie/cowrie.json
DATE=$(date +%Y-%m-%d)

echo "=== Cowrie Honeypot Report - $DATE ==="
echo ""
echo "Total Events: $(cat $LOGFILE | jq -s 'length')"
echo "Unique Attackers: $(cat $LOGFILE | jq -r '.src_ip' | sort -u | wc -l)"
echo "Failed Logins: $(cat $LOGFILE | jq 'select(.eventid == "cowrie.login.failed")' | jq -s 'length')"
echo "Successful Logins: $(cat $LOGFILE | jq 'select(.eventid == "cowrie.login.success")' | jq -s 'length')"
echo "Commands Executed: $(cat $LOGFILE | jq 'select(.eventid == "cowrie.command.input")' | jq -s 'length')"
```

### Visualization Tools

```bash
# Install ELK stack for advanced visualization
# Or use simple Python script
pip3 install matplotlib pandas

# Create visualization
python3 << 'EOF'
import json
import pandas as pd
import matplotlib.pyplot as plt

with open('~/cowrie/var/log/cowrie/cowrie.json') as f:
    logs = [json.loads(line) for line in f]

df = pd.DataFrame(logs)
print(df['eventid'].value_counts())
df['eventid'].value_counts().plot(kind='bar')
plt.savefig('cowrie_events.png')
EOF
```

---

## 🔒 Security Considerations

### ⚠️ Important Warnings

> **Never deploy this honeypot on production systems without proper isolation!**

### Best Practices

1. **Network Isolation**
   ```bash
   # Use a dedicated VLAN or network segment
   # Configure firewall rules to limit outbound traffic
   sudo iptables -A OUTPUT -o eth0 -m owner --uid-owner cowrie -j DROP
   ```

2. **Resource Limits**
   ```bash
   # Limit CPU and memory usage
   sudo systemctl set-property cowrie.service CPUQuota=50%
   sudo systemctl set-property cowrie.service MemoryLimit=1G
   ```

3. **Regular Updates**
   ```bash
   # Keep Cowrie updated
cd ~/cowrie
git pull
source cowrie-env/bin/activate
pip install -r requirements.txt --upgrade
   ```

4. **Log Security**
   ```bash
   # Protect log files
   chmod 600 ~/cowrie/var/log/cowrie/*.json
   chmod 600 ~/cowrie/var/log/cowrie/*.db
   ```

### Firewall Configuration

```bash
# Allow only necessary inbound traffic
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --reload

# Block outbound connections from honeypot
sudo iptables -A OUTPUT -m owner --uid-owner cowrie -j LOG --log-prefix "COWRIE-BLOCK: "
sudo iptables -A OUTPUT -m owner --uid-owner cowrie -j DROP
```

---

## 🐛 Troubleshooting

### Common Issues

#### Issue: Cowrie fails to start

```bash
# Check for port conflicts
sudo netstat -tlnp | grep 2222

# Check logs
cat ~/cowrie/var/log/cowrie/cowrie.log

# Verify virtual environment
source ~/cowrie/cowrie-env/bin/activate
which python
```

#### Issue: Port redirection not working

```bash
# Verify iptables rules
sudo iptables -t nat -L PREROUTING -n -v

# Check if port 22 is already in use
sudo netstat -tlnp | grep :22

# Test with telnet
telnet localhost 22
```

#### Issue: Permission denied errors

```bash
# Fix permissions
sudo chown -R cowrie:cowrie ~/cowrie
chmod -R 755 ~/cowrie

# Check SELinux
sudo setenforce 0  # Temporarily disable for testing
sudo getenforce
```

#### Issue: Logs not being written

```bash
# Check log directory permissions
ls -la ~/cowrie/var/log/cowrie/

# Verify disk space
df -h

# Check configuration
grep -A5 "output_json" ~/cowrie/etc/cowrie.cfg
```

### Debug Mode

```bash
# Run in debug mode
cd ~/cowrie
source cowrie-env/bin/activate
twistd -n cowrie -c etc/cowrie.cfg --debug
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Reporting Issues

Please include:
- Fedora version (`cat /etc/fedora-release`)
- Cowrie version (`cowrie --version`)
- Python version (`python3 --version`)
- Relevant log excerpts
- Steps to reproduce

---

## 📚 Resources

### Official Documentation

- [Cowrie GitHub](https://github.com/cowrie/cowrie)
- [Cowrie Documentation](https://cowrie.readthedocs.io/)
- [Cowrie Slack](https://cowrie.slack.com/)

### Community & Research

- [The Honeynet Project](https://www.honeynet.org/)
- [SANS Internet Storm Center](https://isc.sans.edu/)
- [Shodan](https://www.shodan.io/) - Search for exposed services

### Related Tools

| Tool | Purpose |
|------|---------|
| [Dionaea](https://github.com/DinoTools/dionaea) | Malware capture honeypot |
| [Conpot](https://github.com/mushorg/conpot) | ICS/SCADA honeypot |
| [T-Pot](https://github.com/telekom-security/tpotce) | Multi-honeypot platform |
| [Elastic Stack](https://www.elastic.co/) | Log analysis & visualization |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Cowrie itself is licensed under the BSD 3-Clause License.

---

## 🙏 Acknowledgments

- [Cowrie Team](https://github.com/cowrie/cowrie) for the excellent honeypot software
- [The Honeynet Project](https://www.honeynet.org/) for threat research
- The cybersecurity community for continuous contributions

---

## ⚖️ Disclaimer

> **This project is for educational and research purposes only.**

**⚠️ Important:**

- Do **NOT** expose this honeypot to the public internet without proper security controls
- Always isolate honeypots from production networks
- Be aware of legal implications in your jurisdiction
- Monitor for abuse and respond appropriately
- Never use captured data for malicious purposes

The authors assume no liability for any misuse or damage caused by this software.

---

<p align="center">
  Made with ❤️ for the cybersecurity community
</p>

<p align="center">
  <a href="https://github.com/yourusername/cowrie-honeypot-lab">⭐ Star this repo</a> •
  <a href="https://github.com/yourusername/cowrie-honeypot-lab/issues">🐛 Report Bug</a> •
  <a href="https://github.com/yourusername/cowrie-honeypot-lab/pulls">🔀 Submit PR</a>
</p>

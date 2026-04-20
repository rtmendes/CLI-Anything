#!/bin/bash
# CLI-Anything — One-Command Oracle VPS Deploy
# Run: curl -sSL <this-url> | bash
# Or: bash deploy-oracle.sh

set -euo pipefail

echo "============================================"
echo "  CLI-Anything — Oracle VPS Deployment"
echo "============================================"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "Installing Node.js 20 LTS..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

echo "Node: $(node -v) | npm: $(npm -v)"

# Clone or update
CLI_DIR="/opt/cli-anything"
if [ -d "$CLI_DIR" ]; then
    echo "Updating existing installation..."
    cd "$CLI_DIR" && git pull origin main
else
    echo "Cloning CLI-Anything..."
    sudo git clone https://github.com/rtmendes/CLI-Anything.git "$CLI_DIR"
    sudo chown -R $USER:$USER "$CLI_DIR"
fi

cd "$CLI_DIR"

# Install dependencies for CLIs that need them
echo "Installing CLI dependencies..."
for dir in */; do
    if [ -f "${dir}package.json" ]; then
        echo "  Installing: ${dir%/}"
        (cd "$dir" && npm install --production 2>/dev/null) || true
    fi
done

# Install from public registry
if [ -f "public_registry.json" ]; then
    echo "Installing public registry CLIs..."
    # Extract npm packages from registry
    node -e "
      const reg = require('./public_registry.json');
      const clis = reg.clis || [];
      clis.filter(c => c.install_cmd && c.install_cmd.startsWith('npm')).forEach(c => {
        console.log(c.install_cmd);
      });
    " | while read cmd; do
        echo "  Running: $cmd"
        eval "sudo $cmd" 2>/dev/null || true
    done
fi

# Create global CLI wrapper
sudo tee /usr/local/bin/cli-anything > /dev/null << 'WRAPPER'
#!/bin/bash
CLI_DIR="/opt/cli-anything"
APP="$1"
shift
if [ -d "$CLI_DIR/$APP" ]; then
    cd "$CLI_DIR/$APP"
    if [ -f "index.js" ]; then
        node index.js "$@"
    elif [ -f "main.py" ]; then
        python3 main.py "$@"
    elif [ -f "cli.sh" ]; then
        bash cli.sh "$@"
    else
        echo "No entry point found for $APP"
        exit 1
    fi
else
    echo "CLI not found: $APP"
    echo "Available CLIs:"
    ls -1 "$CLI_DIR" | grep -v "\\." | head -20
    exit 1
fi
WRAPPER
sudo chmod +x /usr/local/bin/cli-anything

# Create systemd health check service
sudo tee /etc/systemd/system/cli-anything-health.service > /dev/null << SYSD
[Unit]
Description=CLI-Anything Health Check
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/cli-anything --health-check
SYSD

sudo tee /etc/systemd/system/cli-anything-health.timer > /dev/null << TIMER
[Unit]
Description=CLI-Anything Health Check Timer

[Timer]
OnCalendar=*:0/15
Persistent=true

[Install]
WantedBy=timers.target
TIMER

echo ""
echo "============================================"
echo "  CLI-Anything deployed successfully!"
echo "  Location: $CLI_DIR"
echo "  Usage: cli-anything <app-name> [args]"
echo "  Example: cli-anything blender --render scene.blend"
echo "============================================"
echo ""
echo "Available CLIs:"
ls -1 "$CLI_DIR" | grep -v "\\." | wc -l
echo " tools installed"
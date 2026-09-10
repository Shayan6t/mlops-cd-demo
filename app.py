import os
import subprocess
from flask import Flask, jsonify, request

app = Flask(__name__)


def get_git_commit():
    commit = os.getenv("GIT_COMMIT")
    if not commit or commit == "local":
        try:
            commit = subprocess.check_output(
                ["git", "rev-parse", "--short", "HEAD"], text=True
            ).strip()
        except Exception:
            commit = "f72ab81"
    return commit


def get_app_version():
    if "APP_VERSION" in os.environ:
        return os.environ["APP_VERSION"]
    try:
        with open("VERSION", "r") as f:
            return f.read().strip()
    except Exception:
        return "1.3.0"


MODEL_VERSION = os.getenv("MODEL_VERSION", "model-7")
APP_VERSION = get_app_version()
GIT_COMMIT = get_git_commit()


@app.route("/")
def home():
    return jsonify({
        "service": "mlops-demo",
        "status": "running"
    })


@app.route("/health")
def health():
    return jsonify({
        "application_version": APP_VERSION,
        "model_version": MODEL_VERSION,
        "git_commit": GIT_COMMIT,
        "status": "healthy"
    })


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    value = float(data["value"])
    # Dummy ML prediction for teaching
    prediction = value * 2
    return jsonify({
        "input": value,
        "prediction": prediction,
        "model_version": MODEL_VERSION
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

import flask

app = flask.Flask(__name__)


@app.route("/")
def index() -> str:
    return "Hello, world!"

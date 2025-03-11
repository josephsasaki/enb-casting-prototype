from flask import Flask
from yohei.extensions import db
from yohei.routes.gender_routes import gender_bp


def create_app():
    app = Flask(__name__)
    app.config.from_object('config')

    # Initialize extensions
    db.init_app(app)

    # Register Blueprints (routes)
    app.register_blueprint(gender_bp, url_prefix='/api')

    return app

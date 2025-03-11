from flask import Blueprint, jsonify, request
from yohei.models.gender import Gender

gender_bp = Blueprint('gender_bp', __name__)


@gender_bp.route('/genders', methods=['GET'])
def get_genders():
    genders = Gender.query.all()
    return jsonify([{"id": g.gender_id, "title": g.gender_title} for g in genders])

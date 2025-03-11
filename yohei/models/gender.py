from yohei.extensions import db


class Gender(db.Model):
    __tablename__ = 'gender'
    __table_args__ = {'autoload_with': db.engine}

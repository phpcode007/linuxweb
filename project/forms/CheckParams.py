# -*- coding: utf-8 -*-
from werkzeug.routing import ValidationError
from wtforms import Form, BooleanField, StringField, validators
# import wtforms_json

from wtforms import Form
from wtforms.fields import BooleanField, TextField
from wtforms.validators import InputRequired


def is_41(form, field):
    if field.data != 41:
        raise ValidationError('请输入正确的域名格式')
        # raise ValidationError('xjq 123')


#验证是不是域名格式
def is_valid_domain(form,field):

    import re
    pattern = re.compile(
        r'^(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|'
        r'([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|'
        r'([a-zA-Z0-9][-_.a-zA-Z0-9]{0,61}[a-zA-Z0-9]))\.'
        r'([a-zA-Z]{2,13}|[a-zA-Z0-9-]{2,30}.[a-zA-Z]{2,10})$'
    )



    #先去重复
    no_copy_data = list(set(form.nginx_domain.data.split('\n')))
    #生成表达式去除空格和字符串前后空格
    check_data = [x.strip() for x in no_copy_data if x.strip() != '']



    for i in check_data:

        if pattern.match(i):
            pass
        else:
            raise ValidationError('请输入正确的域名格式')

    # if pattern.match(form.nginx_domain.data):
    #     pass
    # else:
    #     raise ValidationError('请输入正确的域名格式')




class NginxForm(Form):
    name = TextField('name', validators=[InputRequired()])


class AddWebForm(Form):

    nginx_domain = TextField(validators=[is_valid_domain])





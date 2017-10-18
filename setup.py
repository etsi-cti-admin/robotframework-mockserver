from distutils.core import setup

exec(open('./src/MockServerLibrary/version.py').read())

setup(name='robotframework-mockserver',
      packages=['MockServerLibrary'],
      package_dir={'': 'src'},
      version=VERSION,
      description='Robot framework library for MockServer',
      author='Timo Yrjola',
      author_email='timo.yrjola@gmail.com',
      url='https://github.com/tyrjola/robotframework-mockserver',
      download_url='https://github.com/tyrjola/robotframework-mockserver/archive/{}.tar.gz'.format(VERSION),
      keywords='testing robotframework mockserver',
      classifiers=[])

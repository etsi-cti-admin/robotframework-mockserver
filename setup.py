from distutils.core import setup

exec(open('./src/MockServerLibrary/version.py').read())

setup(name='robotframework-mockserver',
      packages=['MockServerLibrary'],
      package_dir={'': 'src'},
      version=VERSION,
      description='Robot framework library for MockServer',
      author='<TODO>',
      author_email='<TODO>',
      url='https://github.com/etsi-cti-admin/robotframework-mockserver',
      download_url='https://github.com/etsi-cti-admin/robotframework-mockserver/archive/{}.tar.gz'.format(
          VERSION),
      keywords='testing robotframework mockserver',
      classifiers=[])

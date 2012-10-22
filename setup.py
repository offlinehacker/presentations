# -*- coding: utf-8 -*-
"""Installer for this package."""

from setuptools import setup
from setuptools import find_packages

import os


# shamlessly stolen from Hexagon IT guys
def read(*rnames):
    return open(os.path.join(os.path.dirname(__file__), *rnames)).read()

version = '0.1'

setup(name='presentations',
      version=version,
      description="My presentations",
      classifiers=[
        "Programming Language :: Python",
        ],
      keywords='Presentation Slides',
      author='@offlinehacker',
      author_email='jakahudoklin@gmail.com',
      url='http://www.x-truder.net',
      license='BSD',
      packages=find_packages(exclude=['ez_setup']),
      include_package_data=True,
      zip_safe=False,
      install_requires=[
          # list project dependencies
          'sphinx',
          'hieroglyph',
      ],
      )

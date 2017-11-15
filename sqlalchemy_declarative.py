# -*- coding: utf-8 -*-
"""
Created on Thu Feb 25 07:37:45 2016

@author: Amelie
"""

#Python's SQLAlchemy and Declarative
#
#There are three most important components in writing SQLAlchemy code:
#
#A Table that represents a table in a database.
#A mapper that maps a Python class to a table in a database.
#A class object that defines how a database record maps to a normal Python object.
#Instead of having to write code for Table, mapper and the class object at different places, SQLAlchemy's declarative allows a Table, a mapper and a class object to be defined at once in one class definition.
#
#The following declarative definitions specify the same tables defined in sqlite_ex.py:


import os
import sys
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine

os.getcwd()
os.chdir("/Users/Amelie/Dropbox/0_Data_Science_Projects/SQLAlchemy")

#http://docs.sqlalchemy.org/en/latest/core/type_basics.html
#sqlalchemy.types.PickleType(protocol=2, pickler=None, comparator=None) 

Base = declarative_base()
 
class Person(Base):
    __tablename__ = 'person'
    # Here we define columns for the table person
    # Notice that each column is also a normal Python instance attribute.
    id = Column(Integer, primary_key=True)
    name = Column(String(250), nullable=False)
 
class Address(Base):
    __tablename__ = 'address'
    # Here we define columns for the table address.
    # Notice that each column is also a normal Python instance attribute.
    id = Column(Integer, primary_key=True)
    street_name = Column(String(250))
    street_number = Column(String(250))
    post_code = Column(String(250), nullable=False)
    person_id = Column(Integer, ForeignKey('person.id'))
    person = relationship(Person)
 
# Create an engine that stores data in the local directory's
# sqlalchemy_example.db file.
engine = create_engine('sqlite:///sqlalchemy_example.db')
 
# Create all tables in the engine. This is equivalent to "Create Table"
# statements in raw SQL.
Base.metadata.create_all(engine) 



#$ python sqlalchemy_declarative.py
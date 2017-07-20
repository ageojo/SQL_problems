# -*- coding: utf-8 -*-
"""
Created on Thu Feb 25 12:16:54 2016

@author: Amelie
"""

#SQLAlchemy is an open source SQL toolkit and ORM for the Python programming language released under the MIT license. It was released initially in February 2006 and written by Michael Bayer. It provides "a full suite of well known enterprise-level persistence patterns, designed for efficient and high-performing database access, adapted into a simple and Pythonic domain language". It has adopted the data mapper pattern (like Hibernate in Java) rather than the active record pattern (like the one in Ruby on Rails).
#
#SQLAlchemy's unit-of-work principal makes it essential to confine all the database manipulation code to a specific database session that controls the life cycles of every object in that session. Similar to other ORMs, we start by defining subclasses of declarative_base() in order to map tables to Python classes.

from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class Person(Base):
     __tablename__ = 'person'
     id = Column(Integer, primary_key=True)
     name = Column(String)


class Address(Base):
     __tablename__ = 'address'
     id = Column(Integer, primary_key=True)
     address = Column(String)
     person_id = Column(Integer, ForeignKey(Person.id))
     person = relationship(Person)

#Before we write any database code, we need to create an database engine for our db session
from sqlalchemy import create_engine
engine = create_engine('sqlite://')

#Once we have created a database engine, we can proceed to create a database session and create tables for all the database classes previously defined as Person and Address.

from sqlalchemy.orm import sessionmaker
session = sessionmaker()
session.configure(bind=engine)
Base.metadata.create_all(engine)

#Now the session object becomes our unit-of-work constructor and all the subsequent database manipulation code and objects will be attached to a db session constructed by calling its __init__() method.

s = session()
p = Person(name='person')
s.add(p)
a = Address(address='address', person=p)
s.add(a)

#To get or retrieve the database objects, we call query() and filter() methods from the db session object.
p = s.query(Person).filter(Person.name == 'person').one()
p
 
print "%r, %r" % (p.id, p.name)
#1, 'person'
a = s.query(Address).filter(Address.person == p).one()
print "%r, %r" % (a.id, a.address)
#1, 'address'

#Notice that so far we haven't committed any changes to the database yet so that the new person and address objects are not actually stored in the database yet. Calling s.commit() will actually commit the changes, i.e., inserting a new person and a new address, into the database.

s.commit()
s.close()


#SQLAlchemy
#
#Pros:
#
#Enterprise-level APIs; making the code robust and adaptable
#Flexible design; making it painless to write complex queries
#Cons:
#
#The Unit-of-work concept is not common
#A heavyweight API; leading to a long learning curve










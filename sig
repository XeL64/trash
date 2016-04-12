#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Usefull tools for #####
"""

import pyproj
from collections import namedtuple


def convert_lambertZoneII_to_wgs84(gpscoord1,gpscoord2):
    '''
    Convert "LambertZoneII" to "Decimal Degrees"
    >>> gpscoord1 = 662709.565 # longitude
    >>> gpscoord2 = 2222005.707 # latitude
    '''
    wgs84 = pyproj.Proj("+init=EPSG:4326")
    lambertZoneII = pyproj.Proj("+init=EPSG:27572")
    longitude, latitude = pyproj.transform(lambertZoneII,wgs84,gpscoord1,gpscoord2)
    
    return {'latitude':latitude, 'longitude':longitude}


def convert_dd_to_dms(dd_lat,dd_lon):
    '''
    Convert "Decimal Degrees" to "Degrees Minutes Secondes"
    >>> dd_lat = 46.99496576577557 # obtain with convert_lambertZoneII_to_wgs84
    >>> dd_lon = 3.161073598078643 # obtain with convert_lambertZoneII_to_wgs84
    '''
    # convert latitude
    minutes_lat, secondes_lat = divmod(dd_lat*3600, 60)
    degrees_lat, minutes_lat = divmod(minutes_lat, 60)
    
    # convert longitude
    minutes_lon, secondes_lon = divmod(dd_lon*3600, 60)
    degrees_lon, minutes_lon = divmod(minutes_lon, 60)
    
    # templates nametuple
    coords_ntpl = namedtuple('dms_coord', ['degrees', 'minutes', 'secondes', 'cardinal_dir'])
    
    # determine cardinal direction
    if int(degrees_lat) >= 0:
        carinal_lat = 'N'
    else:
        carinal_lat = 'S'

    if int(degrees_lon) >= 0:
        carinal_lon = 'E'
    else:
        carinal_lon = 'W'
    
    latitude = coords_ntpl(int(degrees_lat), int(minutes_lat), secondes_lat, carinal_lat)
    longitude = coords_ntpl(int(degrees_lon), int(minutes_lon), secondes_lon, carinal_lon)
    # ~# if dd_lat >= 0:
    
    return {'latitude':latitude, 'longitude':longitude}


def convert_dd_to_dms_pretty(coords):
    dms_lat_pretty = u'%s%s%s%s%s%s%s' %(
        coords['latitude'].degrees,
        u'°',
        coords['latitude'].minutes,
        u"'",
        coords['latitude'].secondes,
        u'"',
        coords['latitude'].cardinal_dir,
    )
    dms_lon_pretty = u'%s%s%s%s%s%s%s' %(
        coords['longitude'].degrees,
        u'°',
        coords['longitude'].minutes,
        u"'",
        coords['longitude'].secondes,
        u'"',
        coords['longitude'].cardinal_dir,
    )
    
    return u'%s' %(dms_lat_pretty), u'%s' %(dms_lon_pretty)
    
    
def convert_dms_to_dd(dms_lat, dms_lon):
    '''
    Convert "Degrees Minutes Secondes" to "Decimal Degrees"
    '''
    # ~# >>> dms_lat = u"""46°59'41.877"N"""
    # ~# >>> dms_lon = u"""3°50'20.135"E"""
    #parse DMS
    dms_parser = namedtuple('dms_coord', ['degrees', 'minutes', 'secondes', 'cardinal_dir'])
    latitude = dms_parser(
        degrees=dms_lat.split(u'°')[0],
        minutes=dms_lat.split(u'°')[1].split("'")[0],
        secondes=dms_lat.split(u'°')[1].split("'")[1].split('"')[0],
        cardinal_dir=dms_lat.split(u'°')[1].split("'")[1].split('"')[1],
    )
    longitude = dms_parser(
        degrees=dms_lon.split(u'°')[0],
        minutes=dms_lon.split(u'°')[1].split("'")[0],
        secondes=dms_lon.split(u'°')[1].split("'")[1].split('"')[0],
        cardinal_dir=dms_lon.split(u'°')[1].split("'")[1].split('"')[1],
    )
    # ~# print(latitude)
    # ~# print(longitude)
    # ~# import pdb; pdb.set_trace()

    dd_lat = int(latitude.degrees) + float(latitude.minutes) / 60 + float(latitude.secondes) / 3600
    if latitude.cardinal_dir == 'S':
        dd_lat = dd_lat * -1
    
    dd_lon = int(longitude.degrees) + float(longitude.minutes) / 60 + float(longitude.secondes) / 3600
    if latitude.cardinal_dir == 'W':
        dd_lon = dd_lon * -1
    
    return {'latitude': dd_lat, 'longitude': dd_lon}


def parse_db_failure_gpscoord(dms_fail):
    '''
    magic db...
    '''
    
    # dms_lat = u'46\xb057\'\'26.96""N'
    # dms_lon = u'5\xb047\'\'56.97""E'

    dms_ok = dms_fail.replace("'",'',1).replace('"','',1)
    
    return dms_ok


"""
lambertZoneII:
662709.565
2222005.707

Decimal Degrees (DD):
46.99496576577557
3.161073598078643

Degrees Decimal Minutes (DDM):
46° 59,69796' N
3° 9.66444' E

Degrees Minutes Seconds (DMS):
46° 59' 41,8776" N
3°  9'  39,8664" E
"""




require 'formula'

class Pclid < Formula
  homepage 'http://pointclouds.org'
  head 'https://github.com/PointCloudLibrary/pcl.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'boost' 
  depends_on 'qt'
  depends_on 'vtk5id'
  depends_on 'openni' 
  depends_on 'flann'
  depends_on 'eigen'
  depends_on 'cminpack'
  depends_on 'qhull2011id'
  depends_on 'libusb'
  depends_on 'glew'
  
  
  depends_on :python
  
  conflicts_with 'pcl' if Formula.installed.join.include? "pcl"

  def patches
   # DATA
  end

  def install
    qhull2011_base = Formula.factory('qhull2011').installed_prefix
    args = std_cmake_args + %W[
      -DGLEW_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/GL
      -DQHULL_ROOT=#{qhull2011_base}
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_simulation:BOOL=ON
      -DBUILD_outofcore:BOOL=AUTO_OFF
      -DBUILD_people:BOOL=ON
      -DWITH_CUDA:BOOL=OFF
      -DOPENNI_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/ni
      -DBUILD_GPU:BOOL=ON
      -DBUILD_apps:BOOL=ON
      -DBUILD_examples:BOOL=ON
    ]

    mkdir 'macbuild' do
      #puts "#{buildpath}/cmake/Modules/FindGLEW.cmake"
      File.open("#{buildpath}/cmake/Modules/FindGLEW.cmake", 'w') {|f| f.write(DATA.read) }
      system 'cmake', '..', *args
      system "make"
      system "make install"
    end
    
     
  end
end


__END__
# Copyright (c) 2009 Boudewijn Rempt <boud@valdyas.org>                                                                                          
#                                                                                                                                                
# Redistribution and use is allowed according to the terms of the BSD license.                                                                   
# For details see the accompanying COPYING-CMAKE-SCRIPTS file. 
# 
# - try to find glew library and include files
#  GLEW_INCLUDE_DIR, where to find GL/glew.h, etc.
#  GLEW_LIBRARIES, the libraries to link against
#  GLEW_FOUND, If false, do not try to use GLEW.
# Also defined, but not for general use are:
#  GLEW_GLEW_LIBRARY = the full path to the glew library.

IF (WIN32)

  IF(CYGWIN)

    FIND_PATH( GLEW_INCLUDE_DIR GL/glew.h)

    FIND_LIBRARY( GLEW_GLEW_LIBRARY glew32
      ${OPENGL_LIBRARY_DIR}
      /usr/lib/w32api
      /usr/X11R6/lib
    )


  ELSE(CYGWIN)
  
    FIND_PATH( GLEW_INCLUDE_DIR GL/glew.h
      $ENV{GLEW_ROOT}/include
    )

    FIND_LIBRARY( GLEW_GLEW_LIBRARY
      NAMES glew glew32 glew32s
      PATHS
      $ENV{GLEW_ROOT}/lib
      ${OPENGL_LIBRARY_DIR}
    )

  ENDIF(CYGWIN)

ELSE (WIN32)

  IF (APPLE)
# These values for Apple could probably do with improvement.
    FIND_PATH( GLEW_INCLUDE_DIR glew.h
      /System/Library/Frameworks/GLEW.framework/Versions/A/Headers
      ${OPENGL_LIBRARY_DIR}
    )
    FIND_LIBRARY( GLEW_GLEW_LIBRARY GLEW)
    SET(GLEW_cocoa_LIBRARY "-framework Cocoa" CACHE STRING "Cocoa framework for OSX")
  ELSE (APPLE)

    FIND_PATH( GLEW_INCLUDE_DIR GL/glew.h
      /usr/include/GL
      /usr/openwin/share/include
      /usr/openwin/include
      /usr/X11R6/include
      /usr/include/X11
      /opt/graphics/OpenGL/include
      /opt/graphics/OpenGL/contrib/libglew
    )

    FIND_LIBRARY( GLEW_GLEW_LIBRARY GLEW
      /usr/openwin/lib
      /usr/X11R6/lib
    )

  ENDIF (APPLE)

ENDIF (WIN32)

SET( GLEW_FOUND FALSE )
IF(GLEW_INCLUDE_DIR)
  IF(GLEW_GLEW_LIBRARY)
    # Is -lXi and -lXmu required on all platforms that have it?
    # If not, we need some way to figure out what platform we are on.
    SET( GLEW_LIBRARIES
      ${GLEW_GLEW_LIBRARY}
      ${GLEW_cocoa_LIBRARY}
    )
    SET( GLEW_FOUND TRUE )

#The following deprecated settings are for backwards compatibility with CMake1.4
    SET (GLEW_LIBRARY ${GLEW_LIBRARIES})
    SET (GLEW_INCLUDE_PATH ${GLEW_INCLUDE_DIR})

  ENDIF(GLEW_GLEW_LIBRARY)
ENDIF(GLEW_INCLUDE_DIR)

IF(GLEW_FOUND)
  IF(NOT GLEW_FIND_QUIETLY)
    MESSAGE(STATUS "Found Glew: ${GLEW_LIBRARIES}")
  ENDIF(NOT GLEW_FIND_QUIETLY)
  IF(GLEW_GLEW_LIBRARY MATCHES glew32s)
    ADD_DEFINITIONS(-DGLEW_STATIC)
  ENDIF(GLEW_GLEW_LIBRARY MATCHES glew32s)
ELSE(GLEW_FOUND)
  IF(GLEW_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find Glew")
  ENDIF(GLEW_FIND_REQUIRED)
ENDIF(GLEW_FOUND)

MARK_AS_ADVANCED(
  GLEW_INCLUDE_DIR
  GLEW_GLEW_LIBRARY
  GLEW_Xmu_LIBRARY
  GLEW_Xi_LIBRARY
)

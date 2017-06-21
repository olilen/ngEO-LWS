#!/bin/sh -e
##############################################################################
# @copyright TELESPAZIO France 2017. Property of TELESPAZIO France; all rights reserved
# @original Author: TELESPAZIO France
# @maintained by: Telespazion France SAS
# @project NGEO
# @version $Rev:
# @purpose This script installs/uninstalls an NGEO QS subsystem 
# 
# Usage:
# - Installation: ./ngeo-install.sh install
# - Uninstallation: ./ngeo-install.sh uninstall
# - Installation status: ./ngeo-install.sh status
# 
##############################################################################


# ----------------------------------------------------------------------------
# Configuration section
# ----------------------------------------------------------------------------

# Subsystem name
SUBSYSTEM="NGEO Web client and Query Server"

# ----------------------------------------------------------------------------
# End of configuration section
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------
ngeo_install() {  

    echo "------------------------------------------------------------------------------"
    echo " $SUBSYSTEM Install"
    echo "------------------------------------------------------------------------------"  

    # --------------------------------------------------------------------------
    # Install Step 1/3: Uninstall previous version if any
    # --------------------------------------------------------------------------
    if rpm --quiet -q esa-ngeo-qs; then
      echo "------------------------------------------------------------------------------" 
      echo "Step 1/3: Uninstall previous version " 
      echo "------------------------------------------------------------------------------" 
	    ngeo_uninstall
    else
      echo "------------------------------------------------------------------------------" 
      echo "Step 1/3: No previous version installed " 
      echo "------------------------------------------------------------------------------" 
    fi

    # --------------------------------------------------------------------------
    # Step 2/3: Software prerequisites                                           
    # --------------------------------------------------------------------------
    echo "------------------------------------------------------------------------------" 
    echo "Step 2/3: Software prerequisites " 
    echo "------------------------------------------------------------------------------" 
	  if ! ngeo_check_rpm_status "mongodb" ; then 
     exit 0
    fi
    if ! ngeo_check_rpm_status "devtoolset-3-gcc" ; then 
     exit 0
    fi
    if ! ngeo_check_rpm_status "devtoolset-3-gcc-c++" ; then 
     exit 0
    fi
    if ! ngeo_check_rpm_status "nodejs" ; then 
     exit 0
    fi
    # --------------------------------------------------------------------------
    # Step 3/3: NGEO Component Installation and configuration
    # --------------------------------------------------------------------------
    echo "------------------------------------------------------------------------------" 
    echo "Step 3/3: NGEO Component Installation " 
    echo "------------------------------------------------------------------------------" 
	  #sudo yum install -y httpd
	  sudo rpm -Uvh esa-ngeo-qs-1.0-20170620.x86_64.rpm
	

    echo "------------------------------------------------------------------------------" 
    echo " $SUBSYSTEM INSTALLED. " 
    echo "------------------------------------------------------------------------------" 
}

# ----------------------------------------------------------------------------
# Uninstall
# ----------------------------------------------------------------------------
ngeo_uninstall() {
    # --------------------------------------------------------------------------
	  # Step 1/4: Uninstall NGEO Component Configuration as Service 
    # --------------------------------------------------------------------------
    echo "------------------------------------------------------------------------------" 
    echo "Step 1/4: Uninstall $SUBSYSTEM Component Configuration as Service. " 
    echo "------------------------------------------------------------------------------" 
 	echo "Stop NGEO service"
  	#if [ -f /etc/init.d/ngeo ] ; then
  	#	sudo /etc/init.d/ngeo stop
  	
  	#	echo "Delete NGEO service"
  	#	sudo rm -f /etc/init.d/ngeo
  	#fi
	
    # --------------------------------------------------------------------------
    # Step 2/4: Uninstall NGEO Component
    # --------------------------------------------------------------------------
    echo "------------------------------------------------------------------------------" 
    echo "Step 2/4: Uninstall $SUBSYSTEM Component " 
    echo "------------------------------------------------------------------------------" 

    echo "Delete client RPM"
    sudo rpm -e esa-ngeo-qs
    
    # --------------------------------------------------------------------------
    # Step 3/4: Uninstall OSS/COTS
    # --------------------------------------------------------------------------
    echo "------------------------------------------------------------------------------" 
    echo "Step 3/4: Uninstall OSS/COTS " 
    echo "------------------------------------------------------------------------------" 
	  # Nothing to do !
	
    # --------------------------------------------------------------------------
    # Step 4/4: Uninstall Prerequisites
    # --------------------------------------------------------------------------
    echo "------------------------------------------------------------------------------" 
    echo "Step 4/4: Uninstall Prerequisites" 
    echo "------------------------------------------------------------------------------" 
	# Nothing to do !
}

# ----------------------------------------------------------------------------
# Status (check status of a specific RPM)
# ----------------------------------------------------------------------------
ngeo_check_rpm_status () {
    STATUS=`rpm -qa | grep $1`
    if [[ ! -z ${STATUS} ]] ; then
      echo -e "$1: installed"
      return 0
    else
      echo -e "$1: missing. Please install it before" then
      return 1
    fi
}

# ----------------------------------------------------------------------------
# Status
# ----------------------------------------------------------------------------
ngeo_status() {
    echo "------------------------------------------------------------------------------"
    echo " $SUBSYSTEM Installation Status"
    echo "------------------------------------------------------------------------------"
    ngeo_check_rpm_status "esa-ngeo-qs"
}

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------
case "$1" in
install)
    ngeo_install
;;
uninstall)
    echo "------------------------------------------------------------------------------"
    echo " $SUBSYSTEM Uninstall"
    echo "------------------------------------------------------------------------------"
    ngeo_uninstall
;;
status)
    ngeo_status
;;
*)
    echo "Usage: $0 {install|uninstall|status}"
exit 1
;;
esac

# END ########################################################################

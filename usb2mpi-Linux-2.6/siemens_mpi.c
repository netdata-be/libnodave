/*
 * Siemens USB-MPI Serial USB driver
 * 
 * Copyright (C) 2005 Thomas Hergenhahn <thomas.hergenhahn@suse.de>
 * 
 * Largely based on siemens_usb_mpi.c, 
 * Copyright (C) 2005 Greg Kroah-Hartman <gregkh@suse.de>
 *
 *	This program is free software; you can redistribute it and/or
 *	modify it under the terms of the GNU General Public License version
 *	2 as published by the Free Software Foundation.
 */

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/tty.h>
#include <linux/module.h>
#include <linux/usb.h>
#include "usb-serial.h"

/* Version Information */
#define DRIVER_VERSION "Version 0.1 09/26/2005"
#define DRIVER_AUTHOR "Thomas Hergenhahn@web.de http://libnodave.sf.net"
#define DRIVER_DESC "Driver for Siemens USB/MPI adapter"


static struct usb_device_id id_table [] = {
	{ USB_DEVICE(0x908, 0x0004) },	// Vendor and product id for 6ES7-972-0CB20-0XA0
	{ },
};
MODULE_DEVICE_TABLE(usb, id_table);

static struct usb_driver siemens_usb_mpi_driver = {
	.owner =	THIS_MODULE,
	.name =		"Siemens USB-MPI",
	.probe =	usb_serial_probe,
	.disconnect =	usb_serial_disconnect,
	.id_table =	id_table,
};

static struct usb_serial_device_type siemens_usb_mpi_device = {
	.owner =		THIS_MODULE,
	.name =			"Siemens USB-MPI",
	.id_table =		id_table,
	.num_interrupt_in =	NUM_DONT_CARE,
	.num_bulk_in =		NUM_DONT_CARE,
	.num_bulk_out =		NUM_DONT_CARE,
	.num_ports =		1,
};

static int __init siemens_usb_mpi_init(void)
{
	int retval;

	retval = usb_serial_register(&siemens_usb_mpi_device);
	if (retval)
		goto failed_usb_serial_register;
	retval = usb_register(&siemens_usb_mpi_driver);
	if (retval)
		goto failed_usb_register;	
	info (DRIVER_DESC);
	info (DRIVER_VERSION " " DRIVER_AUTHOR);
	return retval;
failed_usb_register:
		usb_serial_deregister(&siemens_usb_mpi_device);
failed_usb_serial_register:
	return retval;
}

static void __exit siemens_usb_mpi_exit(void)
{
	usb_deregister(&siemens_usb_mpi_driver);
	usb_serial_deregister(&siemens_usb_mpi_device);
}

module_init(siemens_usb_mpi_init);
module_exit(siemens_usb_mpi_exit);
MODULE_AUTHOR( DRIVER_AUTHOR );
MODULE_DESCRIPTION( DRIVER_DESC );
MODULE_LICENSE( "GPL" );

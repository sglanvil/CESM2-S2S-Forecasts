#!/usr/bin/env python3
# contact sglanvil
# last edit 18jan2024

import os, sys
cesmroot = os.environ.get('CESM_ROOT')
s2sfcstroot = os.path.join(os.path.dirname(os.path.join(os.path.abspath(__file__))), os.path.pardir)
if cesmroot is None:
    raise SystemExit("ERROR: CESM_ROOT must be defined in environment")
_LIBDIR = os.path.join(cesmroot,"cime","scripts","Tools")
sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(cesmroot,"cime","scripts","lib")
sys.path.append(_LIBDIR)
import glob
from datetime import datetime, timedelta
from standard_script_setup import *
from argparse              import RawTextHelpFormatter
from CIME.utils            import safe_copy

def parse_command_line(args, description):
    parser = argparse.ArgumentParser(description=description,
                                     formatter_class=RawTextHelpFormatter)
    CIME.utils.setup_standard_logging_options(parser)
    parser.add_argument("--date",
                        help="Specify a start Date")
    args = CIME.utils.parse_args_and_handle_standard_logging_options(args, parser)
    cdate = os.getenv("CYLC_TASK_CYCLE_POINT")
    if args.date:
        try:
            date = datetime.strptime(args.date, '%Y-%m-%d')
        except ValueError as verr:
            raise ValueError("Incorrect data format, should be YYYY-MM-DD or YYYY-MM") from verr
    elif cdate:
        date = datetime.strptime(cdate, '%Y-%m-%d')
    else:
        date = datetime.today() - timedelta(days=1)
    return date.strftime("%Y-%m-%d")

def get_data_from_campaignstore(date):
    dest_path = '/glade/derecho/scratch/ssfcst/cesm2cam6_DARTatmlnd/StageIC/rest/{}/'.format(date)
    os.makedirs(dest_path,exist_ok=True)
    # remove all files in the staging directory
    [os.remove(file) for file in glob.iglob(dest_path+'*')]
    atm_source_path = '/glade/campaign/cesm/development/cross-wg/S2S/CESM2/CAMI/CFSv2/'
    lnd_source_path = '/glade/campaign/cesm/development/cross-wg/S2S/land/rest/{}-00000/'.format(date)
    # ----- Deal with the offset ocean time. For this  ocean run, it is real_year=ocean_year-1749
    date_obj = datetime.strptime(date,'%Y-%m-%d')
    ocn_yr = (date_obj.year-1749)
    ocn_date = datetime(ocn_yr, date_obj.month, date_obj.day)
    ocn_date_str = ocn_date.strftime('%Y-%m-%d')
    if len(ocn_date_str) == 9: # the date string should be 10 digits
        ocn_date_str = '0'+ocn_date_str
    print("ocean date is...",ocn_date_str)
    ocn_source_path = '/glade/campaign/cesm/development/cross-wg/S2S/CESM2/OCEANIC/{}-00000/'.format(ocn_date_str)
    if os.path.isdir(ocn_source_path): # and os.path.isdir(lnd_source_path):
        for _file in glob.iglob(ocn_source_path+"/*"):
            safe_copy(_file, dest_path)
        #for _file in glob.iglob(lnd_source_path+"/*"):
        #    safe_copy(_file, dest_path)
    else:
        return "---failed to find ocean and/or land IC files---"

    refname = "b.e21.f09_g17"
    print("Start renaming files...") # actually, I don't think this works at all...
    #for lndfile in glob.iglob(dest_path+"I2000*"):
    #    newfile = lndfile.replace("I2000Clm50BgcCrop.002run",refname)
    #    newfile = lndfile.replace("I2000Clm50BgcCrop.002runContd",refname)
    #    newfile = lndfile.replace("I2000Clm50BgcCrop.002runRealtime",refname)
    #    print("Renaming {} to {}".format(lndfile,newfile))        
    #    os.rename(os.path.join(dest_path,lndfile),os.path.join(dest_path,newfile))
    for ocnfile in glob.iglob(dest_path+"g*_JRA*"):
        newfile = ocnfile.replace("g210.G_JRA.v14.gx1v7.01.dr",refname)
        newfile = ocnfile.replace("g.e21.GIAF_JRA.TL319_g17.ssfcst_03",refname)
        print("Renaming {} to {}".format(ocnfile,newfile))
        os.rename(os.path.join(dest_path,ocnfile),os.path.join(dest_path,newfile))
    print("Done renaming files...")

    #atmIn = os.path.join(atm_source_path,"CESM2_NCEP_0.9x1.25_L32.cam2.i.{}-00000.nc".format(date))
    #atmOut = os.path.join(dest_path,"b.e21.f09_g17.cam.i.{}-00000.nc".format(date))
    #if os.path.isfile(atmOut):
    #    os.remove(atmOut)
    #if os.path.isfile(atmIn):
    #    safe_copy(atmIn,atmOut)
    #else:
    #    return "---failed to find atm IC file---"

def _main_func(description):
    date = parse_command_line(sys.argv, description)
    get_data_from_campaignstore(date)

if __name__ == "__main__":
    _main_func(__doc__)

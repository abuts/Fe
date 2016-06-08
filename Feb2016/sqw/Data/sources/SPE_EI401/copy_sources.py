import shutil,os

source = 'x:'
dest    = r'd:\Users\abuts\Data\Fe\Feb2016\sqw\Data\sources\SPE_EI401'
#
runnums = range(15052,15179)
# Add vanadiums:
runnums = runnums +[15181,15182]
#
fnamef = lambda rn: 'MAP{0:05}.raw'.format(rn)

filelist = map(fnamef,runnums)
for filen in filelist:
    source_f = os.path.join(source,filen)
    dest_f    = os.path.join(dest,filen)
    # 
    print "copying file {0} to {1}".format(source_f,dest_f)
    shutil.copyfile(source_f , dest_f )
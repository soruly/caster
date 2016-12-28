# -*- coding: utf-8 -*-
import glob
import os
import sys
import re
import codecs
from fontTools import ttLib

def shortName(font):
		fontName = u""
		altNames = []
		for record in font['name'].names:
			#print record.string
			#print record.langID
			if record.nameID == 4:
				#print record.langID
				if record.langID == 0:
					try:
						if record.string[0] == '\x00' or record.string[0] > '\x80' :
							print unicode(record.string, 'utf-16-be').encode('utf-8')
							altNames.append(unicode(record.string, 'utf-16-be').encode('utf-8'))
							if not fontName:
								fontName = record.string
						else:
							print record.string
							if not fontName:
								fontName = record.string
					except:
						print record.string
						if not fontName:
							fontName = record.string
				elif record.langID == 11:
					print record.string.decode('shift_jisx0213').encode('utf-8')
					altNames.append(record.string.decode('shift_jisx0213').encode('utf-8'))
				elif record.langID == 19:
					try:
						print record.string.decode('big5').encode('utf-8')
						altNames.append(record.string.decode('big5').encode('utf-8'))
					except:
						try: #try strange unicode first
							normalUnicode = unicode(record.string, 'utf-16-be')
							strangeUnicode = unicode(record.string, 'utf-16-be').encode('iso-8859-1').decode('big5')
							if len(strangeUnicode) * 2 == len(normalUnicode):
								print strangeUnicode.encode('utf-8')
								altNames.append(strangeUnicode.encode('utf-8'))
						except: #normal unicode
							try:
								print unicode(record.string, 'utf-16-be').encode('utf-8')
								altNames.append(unicode(record.string, 'utf-16-be').encode('utf-8'))
							except:
								print "19 Failed"
								#print record.string
				elif record.langID == 23:
					print record.string.decode('euc-kr').encode('utf-8')
					altNames.append(record.string.decode('euc-kr').encode('utf-8'))
				elif record.langID == 33:
					print record.string.decode('gbk').encode('utf-8')
					altNames.append(record.string.decode('gbk').encode('utf-8'))
				elif record.langID > 1000:
					try:
						if record.langID == 1033: #US
							if not fontName:
								fontName = record.string
						elif record.langID == 1041: #JP
							try:
								if record.string[0] != '\x00':
									print record.string.decode('shift_jisx0213').encode('utf-8')
									altNames.append(record.string.decode('shift_jisx0213').encode('utf-8'))
								else:
									print record.string.decode('This line give error')
									
							except:
								try:
									print unicode(record.string, 'utf-16-be').encode('iso-8859-1').decode('shift_jisx0213').encode('utf-8')
									altNames.append(unicode(record.string, 'utf-16-be').encode('iso-8859-1').decode('shift_jisx0213').encode('utf-8'))
								except:
									print unicode(record.string, 'utf-16-be').encode('utf-8')
									altNames.append(unicode(record.string, 'utf-16-be').encode('utf-8'))
						elif record.langID == 1042: #KR
							print record.string.decode('euc-kr').encode('utf-8')
							altNames.append(record.string.decode('euc-kr').encode('utf-8'))
						elif record.langID == 2052: #CN
							try:
								if record.string[0] >= '\xA1':
									print record.string.decode('gbk').encode('utf-8')
									altNames.append(record.string.decode('gbk').encode('utf-8'))
								else:
									print record.string.decode('This line give error')
							except:
								try:
									#if len(strangeUnicode) * 2 == len(unicode(record.string, 'utf-16-be')):
									print unicode(record.string, 'utf-16-be').encode('iso-8859-1').decode('gbk').encode('utf-8')
									altNames.append(unicode(record.string, 'utf-16-be').encode('iso-8859-1').decode('gbk').encode('utf-8'))
								except:
									print unicode(record.string, 'utf-16-be').encode('utf-8')
									altNames.append(unicode(record.string, 'utf-16-be').encode('utf-8'))
						elif record.langID == 1028 or record.langID == 3076: #HK TW
							try:
								print record.string.decode('big5').encode('utf-8')
								altNames.append(record.string.decode('big5').encode('utf-8'))
							except:
								try:
									#if len(strangeUnicode) * 2 == len(unicode(record.string, 'utf-16-be')):
									print unicode(record.string, 'utf-16-be').encode('iso-8859-1').decode('big5').encode('utf-8')
									altNames.append(unicode(record.string, 'utf-16-be').encode('iso-8859-1').decode('big5').encode('utf-8'))
								except:
									print unicode(record.string, 'utf-16-be').encode('utf-8')
									altNames.append(unicode(record.string, 'utf-16-be').encode('utf-8'))
						else:
							print unicode(record.string, 'utf-16-be').encode('utf-8')
							altNames.append(unicode(record.string, 'utf-16-be').encode('utf-8'))
					except:
						print "shit"
				else:
					print "decode error"
					#print record.string
					#print record.string.decode('shift_jisx0213').encode('utf-8')
		
		print "fontName ",fontName
		if not fontName:
			print "No fontName"
		print "===================="
		return fontName, altNames

reload(sys)  
sys.setdefaultencoding('utf8')

fontConfig = file('fonts.conf','w')
header = "<?xml version=\"1.0\"?>\n"
header += "<fontconfig>\n"
header += "\n"
header += "<!--<dir>C:\Windows\Fonts</dir>-->\n"
header += "<dir>"+os.path.dirname(os.path.realpath(__file__))+"</dir>\n"
header += "<cachedir>"+os.path.dirname(os.path.realpath(__file__))+"\cache</cachedir>\n"
header += "\n"

footer = "\n"
footer = "\n</fontconfig>"

fontConfig.write(header+"\n")

for file in os.listdir(u"."):
	extension = os.path.splitext(file)[1]
	if extension.lower() == ".ttf":
		print file.encode('utf-8')
		
		tt = ttLib.TTFont(file, fontNumber=0,  ignoreDecompileErrors=True)
		fontName, altNames = shortName(tt)
		if re.match(r'^[0-9a-zA-Z _\-]+$', fontName):
			#linebuffer = fontName+","
			#fontConfig.write(fontName+",")
			#fileList.append(fontName)
			for altName in altNames:
				if not '\x00' in altName:
					fontConfig.write('<match target="pattern">'+"\n")
					fontConfig.write('<test qual="any" name="family"><string>'+altName+'</string></test>'+"\n")
					fontConfig.write('<edit name="family" mode="assign"><string>'+fontName+'</string></edit>'+"\n")
					fontConfig.write('</match>'+"\n")
					
				#print fontName,altName
			fontConfig.write("\n")
		#try:
		#	os.rename(file,fontName+extension.lower())
		#except:
		#	print fontName+extension.lower()+" already exists"
fontConfig.write(footer)
fontConfig.close()
#fileList.sort()
#for file in fileList:
	#print file
#fontList.sort()
#a = list(set(fontList))
#a.sort()
#for file in a:
#	print file
		
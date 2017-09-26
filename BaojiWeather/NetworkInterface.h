//
//  NetworkInterface.h
//  BaojiWeather
//
//  Created by Tcy on 2017/2/16.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#ifndef NetworkInterface_h
#define NetworkInterface_h

#define URLHOST @"http://61.150.127.155:5001"
#define UserRegisterUrl @"http://61.150.127.155:8081/akpublic/userdata?"

#define RemindUrl @"http://61.150.127.155:8081/akpublic/version?ver=ios"

#define MainCityNameUrl @"http://61.150.127.155:8081/akpublic/wf?"
#define WarningUrl @"http://61.150.127.155:8081/akpublic/warning?"
#define MainCityIdUrl @"http://61.150.127.155:8081/akpublic/life?cityid=%@"
#define webUrl1 @"http://61.150.127.155:8081/akpublic/html/meteorologicDisasters.htm"
#define webUrl2 @"http://61.150.127.155:8081/akpublic/html/floodDrought.htm"
#define webUrl3 @"http://61.150.127.155:8081/akpublic/html/geologicHazard.htm"
#define webUrl4 @"http://61.150.127.155:8081/akpublic/html/forestFire.htm"
#define webUrl5 @"http://61.150.127.155:8081/akpublic/html/theEarthquake.htm"
#define webUrl6 @"http://61.150.127.155:8081/akpublic/html/avianInfluenza.htm"
#define webUrl7 @"http://61.150.127.155:8081/akpublic/html/fire.htm"
#define baikeUrl @"http://wapbaike.baidu.com/item/%@"

#define MarkIamgeUrl @"http://61.150.127.155:8081/akpublic/fallrain?sel=img&hours=%@"

#define FallPageUrl @"http://61.150.127.155:8081/akpublic/TempOrWaterServlet?type=N2"
#define TemperturePageUrl @"http://61.150.127.155:8081/akpublic/TempOrWaterServlet?type=N3"

#define FallWithTimeUrl @"http://61.150.127.155:8081/akpublic/fallrain?sel=data&hours=%@"

#define FallPointlist @"http://61.150.127.155:8081/akpublic/fallrain?sel=rain_poit&hours=0"

#define FallPointDetail @"http://61.150.127.155:8081/akpublic/fallrain?sel=24data&site_id=%@"

#define AirQualityMainPage @"http://61.150.127.155:8081/akpublic/airqulity?type=2"
#define AirQualityDetail @"http://61.150.127.155:8081/akpublic/airqulity?"
#define RadarImageList @"http://61.150.127.155:8081/akpublic/c_r_img?sel=r&pos=one"
#define RadarsImageList @"http://61.150.127.155:8081/akpublic/c_r_img?sel=r&pos=more"
#define RadarImage @"http://61.150.127.155:8081/akpublic/radarsigle/%@"
#define RadarsImage @"http://61.150.127.155:8081/akpublic/radar/%@"
#define NearPoint @"http://61.150.127.155:8081/akpublic/n_p_s"
#define TownForecast @"http://61.150.127.155:8081/akpublic/baoji/country.html"
#define CommenSence @"http://www.bjqx.gov.cn:8081/akpublic/page/Risksense.html"
#define Yingji @"http://61.150.127.155:8081/akpublic/yjya/ak.html"
#define MeteorologicalLaw @"http://61.150.127.155:8081/akpublic/page/Meteorologicalregulations.html"
#define YujiSign @"http://61.150.127.155:8081/akpublic/page/qxzhyjxhjfygn.htm"
#define AddressBook @"http://61.150.127.155:8081/akpublic/disaster_prevention?"

#define QiXiang @"http://61.150.127.155:8081/akLedserver/PdfJosnServlet?"
#define PDFUrl @"http://61.150.127.155:8081/akLedserver/PdfWriteOutServlet?prentid=%@"
#define YJSignal @"http://61.150.127.155:8081/akpublic/warningposition?param=1"
#define YuJingURL @"http://61.150.127.155:8081/akpublic/sp?push=%@"



#endif /* NetworkInterface_h */

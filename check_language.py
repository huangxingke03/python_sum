import os
import shutil
import xml.etree.ElementTree as ET
import pickle
import json
from dataclasses import dataclass, asdict
import pandas as PD
import sys

print("。。。。。开始读取xml语言资源。。。。。")
file_path_en = "/home/huangxingke/work/code/workCode/VoiceAssistant/International/src/main/res/values-en/strings.xml"
file_path_es = "/home/huangxingke/work/code/workCode/VoiceAssistant/International/src/main/res/values-es/strings.xml"
excel_path = "/home/huangxingke/project/Python/resource/excel/CL_JT_CS_FY_000-1.xlsx"


def read_xml_file(file_path):
    try:
        xml_string = ""
        with open(file_path, "r", encoding="utf-8") as file:
            xml_string = file.read()
            return xml_string
    except FileNotFoundError:
        print(f"错误 ： 找不到文件 '{file_path}'，请检查文件路径是否正确")
        return None
    except PermissionError:
        print(f"错误 ： 没有权限读取文件 '{file_path}'")
        return None
    except Exception as e:
        print(f"读取文件时发生未知错误 ：{str(e)}")
        return None


@dataclass
class XmlLanguageBean:
    xmlKey: str
    xmlValue: str

    def to_dict(self):
        return asdict(self)


@dataclass
class ExcelLanguageBean:
    chineseReply: str
    englishReply: str
    # 葡萄牙语（巴葡）
    portugalBrazilReply: str
    # 阿拉伯语
    arabicReply: str
    # 西班牙语
    spanishReply: str
    # 俄罗斯语
    russianReply: str

    def to_dict(self):
        return asdict(self)


if __name__ == "__main__":
    xmlLanguageEnList = []
    contentEn = read_xml_file(file_path_en)
    if contentEn is not None:
        print("xml英文文言读取完毕")
        root = ET.fromstring(contentEn)
        xmlLanguageCount = 0
        for string_elm in root.findall("string"):
            key_name = string_elm.get("name")
            value_name = string_elm.text
            xmlLanguageCount += 1
            xmlLanguageEnList.append(XmlLanguageBean(key_name, value_name))
            # print(f"key_name : {key_name} ， value_name : {value_name}")
        # print(f"xml源数据条数 ： {xmlLanguageCount}")
        # print(
        #     json.dumps(
        #         [bean.to_dict() for bean in xmlLanguageEnList],
        #         indent=4,
        #         ensure_ascii=False,
        #     )
        # )
        print(f"xml英语文言资源条数 : {len(xmlLanguageEnList)}")
    # xmlLanguageEsList = []
    # contentEs = read_xml_file(file_path_es)
    print("读取excel资源")
    # print(f"python 版本 ：{sys.version} python ， 解释器版本 : {sys.executable}")

    df = PD.read_excel(
        excel_path,
        sheet_name="Sheet1",
        header=0,
        usecols="E:J",  # 只读取 A 到 F 列（或列表 ["姓名","年龄"]）
        engine="openpyxl",  # 推荐引擎（读写 .xlsx 最稳定）
        na_values=["-", "N/A", ""],  # 把这些值识别为 NaN（缺失值）
        nrows=5,  # 只读前 500 行（大数据时节省内存）
        dtype=str,  # 强制转为字符串 {"手机号": str, "身份证号": str}
    )
    columnsList = df.columns.tolist()
    print(
        "excel文言表头数据 : \n",
        f"{json.dumps(columnsList, indent=4, ensure_ascii=False)}",
    )
    excelShape = df.shape
    print("excel行数，列数：\n", excelShape)
    for index, row in df.iterrows():
        chineseExcelValue = row["chinese_reply"]
        enExcelValue = row["en"]
        arabicExcelValue = row["阿拉伯语"]
        spanishExcelValue = row["西班牙语"]
        russianExcelValue = row["俄罗斯语"]
        portugalBrazilExcelValue = row["葡萄牙语（巴葡）"]
        # print(
        #     f"第 {index} 行 chinese_reply = {chineseExcelValue}  \n enExcelValue = {enExcelValue}  \n arabicExcelValue = {arabicExcelValue} \n spanishExcelValue = {spanishExcelValue} \n russianExcelValue = {russianExcelValue}  \n portugalBrazilExcelValue = {portugalBrazilExcelValue}"
        # )

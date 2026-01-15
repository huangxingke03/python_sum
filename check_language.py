import os
import shutil
import xml.etree.ElementTree as ET
import pickle
import json
from dataclasses import dataclass, asdict
import pandas as PD
import sys

file_path_en = "/home/huangxingke/work/code/workCode/VoiceAssistant/International/src/main/res/values-en/strings.xml"
file_path_es = "/home/huangxingke/work/code/workCode/VoiceAssistant/International/src/main/res/values-es/strings.xml"
file_excel_path = (
    "/home/huangxingke/project/Python/resource/excel/CL_JT_CS_FY_000-1.xlsx"
)


def read_xml_file(file_path):
    try:
        xml_string = ""
        xmlLanguageList = []
        with open(file_path, "r", encoding="utf-8") as file:
            # 获取xml文件内容字符串
            xml_string = file.read()
            if xml_string is not None:
                # 读取xml字符串数据
                root = ET.fromstring(xml_string)
                for string_elm in root.findall("string"):
                    key_name = string_elm.get("name")
                    value_name = string_elm.text
                    xmlLanguageList.append(XmlLanguageBean(key_name, value_name))
                return xmlLanguageList
    except FileNotFoundError:
        print(f"错误 ： 找不到文件 '{file_path}'，请检查文件路径是否正确")
        # 报错返回空列表
        return []
    except PermissionError:
        print(f"错误 ： 没有权限读取文件 '{file_path}'")
        # 报错返回空列表
        return []
    except Exception as e:
        print(f"读取文件时发生未知错误 ：{str(e)}")
        # 报错返回空列表
        return []


def read_excel_file(excel_path):
    try:
        excelLanguageResouceList = []
        df = PD.read_excel(
            excel_path,
            sheet_name="Sheet1",
            header=0,
            usecols="E:J",  # 只读取 A 到 F 列（或列表 ["姓名","年龄"]）
            engine="openpyxl",  # 推荐引擎（读写 .xlsx 最稳定）
            na_values=["-", "N/A", ""],  # 把这些值识别为 NaN（缺失值）
            # nrows=5,  # 只读前 500 行（大数据时节省内存）
            dtype=str,  # 强制转为字符串 {"手机号": str, "身份证号": str}
        )
        columnsList = df.columns.tolist()
        print(
            "excel文言表头数据 : \n",
            f"{json.dumps(columnsList, indent=4, ensure_ascii=False)}",
        )
        excelShape = df.shape
        print("excel行数，列数：\n", excelShape)
        columns_to_check = [
            "chinese_reply",
            "en",
            "阿拉伯语",
            "西班牙语",
            "俄罗斯语",
            "葡萄牙语（巴葡）",
        ]
        for index, row in df.iterrows():
            # 每条中文文言对应的几种外语文言都为有效值时，该条数据为有效数据
            if row[columns_to_check].notna().all():
                zhExcelValue = row["chinese_reply"]
                enExcelValue = row["en"]
                arExcelValue = row["阿拉伯语"]
                esExcelValue = row["西班牙语"]
                ruExcelValue = row["俄罗斯语"]
                ptRbrExcelValue = row["葡萄牙语（巴葡）"]
                excelLanguageBean = ExcelLanguageBean(
                    zhExcelValue,
                    enExcelValue,
                    ptRbrExcelValue,
                    arExcelValue,
                    esExcelValue,
                    ruExcelValue,
                )
                if excelLanguageResouceList not in excelLanguageResouceList:
                    excelLanguageResouceList.append(excelLanguageBean)
        return excelLanguageResouceList
    except Exception as e:
        print(f"读取Excel文件时发生未知错误 ：{str(e)}")
        # 报错返回空列表
        return []


@dataclass
class XmlLanguageBean:
    xmlKey: str
    xmlValue: str

    def to_dict(self):
        return asdict(self)


@dataclass
class ExcelLanguageBean:
    zhReply: str
    enReply: str
    # 葡萄牙语（巴葡）
    ptRbrReply: str
    # 阿拉伯语
    arReply: str
    # 西班牙语
    esReply: str
    # 俄罗斯语
    ruReply: str

    def to_dict(self):
        return asdict(self)


if __name__ == "__main__":
    xmlLanguageEnList = read_xml_file(file_path_en)
    print(f"xml英语文言资源条数 : {len(xmlLanguageEnList)}")
    xmlEsList = read_xml_file(file_path_es)
    print(f"xml西班牙语文言资源条数 : {len(xmlEsList)}")

    print("----读取excel资源----")
    excelLanguageList = read_excel_file(file_excel_path)
    print(f"excel最终读取数据行数 ： {len(excelLanguageList)}")

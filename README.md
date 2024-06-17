# Asciidoctor-docker-jp

このプロジェクトは、Asciidoctorを使用して日本語のPDF文書を生成するための環境を提供します。
Dockerとdocker-composeを利用して、簡単に環境構築して、日本語のPDF作成できるようにすることがプロジェクトの目的です。

## 前提条件

以下のソフトウェアがWSLから実行可能であること

- docker
- docker-compose

まだインストールしていない場合は、以下のコマンドでインストールする。
```sh
sudo apt update && sudo apt upgrade
sudo apt install docker.io docker-compose 
```

## セットアップ手順

WSL(Ubuntu)側のターミナルより下記コマンドを実行して、プロジェクトをcloneする。

```sh
git clone https://github.com/funap/asciidoctor-docker-jp.git
```

## PDF作成手順

WSL(Ubuntu)側のターミナルより`docker-compose up`でPDFが作成できます。

```sh
cd asciidoctor-docker-jp
docker-compose up
```
初回実行時のみ、dockerイメージのビルドが行われるので時間がかかります。

## カスタマイズ

asciidoctor-pdfのコマンドラインの引数を編集したい場合は、`Makefile`を編集してください。

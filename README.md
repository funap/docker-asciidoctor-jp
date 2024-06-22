# Asciidoctor-docker-jp

このプロジェクトは、Asciidoctorを使用して日本語のPDF文書を生成するための環境を提供します。
Podman Desktopが動作する環境で簡単に日本語のPDF作成できるようにすることがプロジェクトの目的です。

## 前提条件

Podman DesktopをWindowsにインストールする
```sh
winget install -e --id RedHat.Podman-Desktop
```

## PDF作成手順

エクスプローラのアドレスバーにpwshと入力後してコンソールを開き、`podman compose up`でPDFが作成できます。

```sh
podman compose up
```
初回実行時のみ、イメージのビルドが行われるので時間がかかります。

## カスタマイズ

asciidoctor-pdfのコマンドラインの引数を編集したい場合は、`Makefile`を編集してください。

# -*- coding: utf-8 -*-

# Spider para o site kabum.com.br

import scrapy

from estou_barato.items import EstouBaratoItem


class KabumSpider(scrapy.Spider):
    name = "kabum"
    allowed_domains = ["kabum.com.br"]
    start_urls = [
        "http://www.kabum.com.br/gamer?ordem=5&limite=100&dep=2412&sec=&cat=&sub=&pagina=1&string=",
    ]

    #
    # Product parse method
    def parse_product(self, response):

        #
        # Create an item
        item = EstouBaratoItem()
        item['name'] = response.xpath('//*[@class="titulo_det"]/text()').extract_first()
        item['preco_av'] = response.xpath('//*[@class="preco_desconto"]/span/strong/text()').extract_first()
        item['image'] = response.xpath('//*[@id="imagem-slide"]/li/img/@src').extract_first()
        item['link'] = response.url

        #
        #  Save item
        yield item


    #
    # Main parse method
    def parse(self, response):

        #
        # Next page

        # Get next page URL ...
        url = response.urljoin(response.xpath('//a[contains(text(), "Proxima")]/@href').extract_first())

        # ... and recursively yield next page parse request
        #print url
        yield scrapy.Request(url, callback=self.parse)


        #
        # Product page

        # Get product URL list
        products = response.xpath('//*[@class="H-titulo"]/a/@href')
        # For each product in list ...
        for product in products:
            # ... yield a parse request
            #print product.extract()
            yield scrapy.Request(product.extract(), callback=self.parse_product)


game_urls = [
    "http://www.kabum.com.br/gamer?ordem=5&limite=100&dep=2412&sec=&cat=&sub=&pagina=1&string=",
]

monitor_urls = [
    "http://www.kabum.com.br/computadores/monitores?ordem=5&limite=100&dep=04&sec=36&cat=&sub=&pagina=1&string="
]

tv_urls = [
    "http://www.kabum.com.br/video-som/tv?ordem=5&limite=100&dep=2413&sec=3087&cat=&sub=&pagina=1&string="
]

vga_urls = [
    "http://www.kabum.com.br/hardware/placa-de-video-vga?ordem=5&limite=100&dep=01&sec=14&cat=&sub=&pagina=1&string="
]

tv_capture_urls = [
    "http://www.kabum.com.br/hardware/placas-tv-edicao?ordem=5&limite=100&dep=01&sec=13&cat=&sub=&pagina=1&string="
]

class KabumGamesSpider(KabumSpider):
    name = "kabum-games"
    start_urls = game_urls

class KabumAllSpider(KabumSpider):
    name = "kabum"
    start_urls = game_urls + monitor_urls + tv_urls + vga_urls + tv_capture_urls
# -*- coding: utf-8 -*-

# EstouBaratoSpider defines a base class

import scrapy
import time
import random

from estou_barato.items import EstouBaratoItem

class EstouBaratoSpider(scrapy.Spider):

    #
    # Get next page url
    def get_next_page_url(self, response):
        return response.urljoin(response.xpath(self.next_page_xpath).extract_first())

    #
    # Product parse method
    def parse_product(self, response):

        #
        # Create an item
        item = EstouBaratoItem()

        # Set product link
        item['link'] = response.url

        # Set item name
        item['name'] = response.xpath(self.product['name']).extract_first()

        # Set sales price
        if self.product.has_key('preco_av'):
            preco_av = response.xpath(self.product['preco_av']).extract_first()
            if isinstance(preco_av, unicode):
                item['preco_av'] = ' '.join(preco_av.split())
            else:
                item['estoque'] = 0

        # Set regular price
        if self.product.has_key('preco'):
            preco = response.xpath(self.product['preco']).extract_first()
            print preco
            if isinstance(preco, unicode):
                item['preco'] = ' '.join(preco.split())

        # Set image link
        if self.product.has_key('preco'):
            item['image'] = response.xpath(self.product['image']).extract_first()

        # Set store name
        if self.product.has_key('loja'):
            loja = response.xpath(self.product['loja']).extract_first()
            if loja is not None:
                item['loja'] = loja
        else:
            item['loja'] = self.default_store

        #
        #  Save item
        yield item

    #
    # Main parse method
    def parse(self, response):

        #
        # Next page

        # Get next page URL ...
        url = self.get_next_page_url(response)
        # print url

        # ... and recursively yield next page parse request
        if self.pace is not None:
            time.sleep(random.random() * self.pace)
        # print url
        yield scrapy.Request(url, callback=self.parse)

        #
        # Product page

        # Get product URL list
        products = response.xpath(self.product_url_xpath)
        # For each product in list ...
        for product in products:
            # ... yield a parse request
            if self.pace is not None:
                time.sleep(random.random()*self.pace)
            # print product.extract()
            yield scrapy.Request(product.extract(), callback=self.parse_product)
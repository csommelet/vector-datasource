# -*- encoding: utf-8 -*-
from . import FixtureTest


class AddDirectionToPOIs(FixtureTest):

    def test_direction_as_cardinal_abbreviation(self):
        import dsl

        z, x, y = (16, 10482, 25333)

        self.generate_fixtures(
            # https://www.openstreetmap.org/node/665689214
            dsl.point(665689214, (-122.4195493, 37.7653381), {
                'tourism': u'viewpoint',
                'direction': u'NW',
                'name': u'Immigrant Point Overlook',
            }),
        )

        self.assert_has_feature(
            z, x, y, 'pois', {
                'id': 665689214,
                'kind': u'viewpoint',
                'direction': 315,
            })

    def test_direction_as_int(self):
        import dsl

        z, x, y = (16, 10482, 25333)

        self.generate_fixtures(
            # https://www.openstreetmap.org/node/3109053718
            dsl.point(3109053718, (-122.4195493, 37.7653381), {
                'tourism': u'viewpoint',
                'direction': u'270',
            }),
        )

        self.assert_has_feature(
            z, x, y, 'pois', {
                'id': 3109053718,
                'kind': u'viewpoint',
                'direction': 270,
            })

    def test_direction_as_cardinal_abbreviation_bad(self):
        import dsl

        z, x, y = (16, 10482, 25333)

        self.generate_fixtures(
            # https://www.openstreetmap.org/node/665689214
            dsl.point(665689214, (-122.4195493, 37.7653381), {
                'tourism': u'viewpoint',
                'direction': u'ZZZ',
            }),
        )

        self.assert_has_feature(
            z, x, y, 'pois', {
                'id': 665689214,
                'kind': u'viewpoint',
            })

        self.assert_no_matching_feature(
            z, x, y, 'pois', {
                'id': 665689214,
                'kind': u'viewpoint',
                'direction': u'ZZZ',
            })

    def test_direction_as_int_out_of_range(self):
        import dsl

        z, x, y = (16, 10482, 25333)

        self.generate_fixtures(
            # https://www.openstreetmap.org/node/3109053718
            dsl.point(3109053718, (-122.4195493, 37.7653381), {
                'tourism': u'viewpoint',
                'direction': u'500',
            }),
        )

        self.assert_has_feature(
            z, x, y, 'pois', {
                'id': 3109053718,
                'kind': u'viewpoint',
            })

        self.assert_no_matching_feature(
            z, x, y, 'pois', {
                'id': 3109053718,
                'kind': u'viewpoint',
                'direction': 500,
            })

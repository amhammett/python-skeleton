import unittest

from src import skeleton


class TestSkeleton(unittest.TestCase):
    def test_import(self):
        self.assertTrue(skeleton)

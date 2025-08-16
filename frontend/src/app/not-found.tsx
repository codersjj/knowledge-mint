import Link from "next/link";
import { BookOpen, Home, Search, Plus } from "lucide-react";

export default function NotFound() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 flex items-center justify-center px-4">
      <div className="max-w-md mx-auto text-center">
        <div className="w-24 h-24 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full flex items-center justify-center mx-auto mb-6">
          <BookOpen className="w-12 h-12 text-white" />
        </div>

        <h1 className="text-6xl font-bold text-gray-900 mb-4">404</h1>
        <h2 className="text-2xl font-semibold text-gray-700 mb-4">
          Page Not Found
        </h2>
        <p className="text-gray-600 mb-8">
          The page you're looking for doesn't exist. It might have been moved,
          deleted, or you entered the wrong URL.
        </p>

        <div className="space-y-4">
          <Link
            href="/"
            className="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-3 px-6 rounded-lg font-semibold hover:from-blue-700 hover:to-purple-700 transition-all duration-200 flex items-center justify-center gap-2"
          >
            <Home className="w-5 h-5" />
            Go Home
          </Link>

          <div className="grid grid-cols-2 gap-4">
            <Link
              href="/browse"
              className="border-2 border-gray-300 text-gray-700 py-3 px-4 rounded-lg font-medium hover:border-gray-400 hover:bg-gray-50 transition-all duration-200 flex items-center justify-center gap-2"
            >
              <Search className="w-4 h-4" />
              Browse Content
            </Link>

            <Link
              href="/publish"
              className="border-2 border-gray-300 text-gray-700 py-3 px-4 rounded-lg font-medium hover:border-gray-400 hover:bg-gray-50 transition-all duration-200 flex items-center justify-center gap-2"
            >
              <Plus className="w-4 h-4" />
              Publish
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
